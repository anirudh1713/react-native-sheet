#import "RnBsView.h"

#import <React/RCTLog.h>
#import <React/RCTSurfaceTouchHandler.h>

#import <react/renderer/components/RnBsViewSpec/EventEmitters.h>
#import <react/renderer/components/RnBsViewSpec/Props.h>
#import <react/renderer/components/RnBsViewSpec/RCTComponentViewHelpers.h>

#import "rnbs/RNBSSheetComponentDescriptor.h"

#import "RCTConversions.h"

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

// @TODO: move controller to its own file(s)
@interface RnBsHostViewController: UIViewController

@property (nonatomic, copy) void (^boundsDidChange)(CGRect newBounds);

@end

@implementation RnBsHostViewController {
  RCTSurfaceTouchHandler *_touchHandler;
  CGRect _lastFrame;
}

- (instancetype)init
{
  if (!(self = [super init])) {
    return nil;
  }
  _touchHandler = [RCTSurfaceTouchHandler new];

  return self;
}

- (void)loadView
{
  self.view = [RCTViewComponentView new];
  [_touchHandler attachToView:self.view];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  
  NSLog(@"TRANSITION FRAME -> width: %f -- height: %f", size.width, size.height);
  NSLog(@"TRANSITION BOUNDS -> width: %f -- height: %f", size.width, size.height);
}

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];
  
  NSLog(@"FRAME -> width: %f -- height: %f", self.view.frame.size.width, self.view.frame.size.height);
  NSLog(@"BOUNDS -> width: %f -- height: %f", self.view.bounds.size.width, self.view.frame.size.height);
  
  if (self.boundsDidChange && !CGRectEqualToRect(_lastFrame, self.view.frame)) {
    self.boundsDidChange(self.view.bounds);
    _lastFrame = self.view.frame;
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  NSLog(@"DID LAYOUT FRAME -> width: %f -- height: %f", self.view.frame.size.width, self.view.frame.size.height);
  NSLog(@"DID LAYOUT BOUNDS -> width: %f -- height: %f", self.view.bounds.size.width, self.view.frame.size.height);
  
//  if (self.boundsDidChange && !CGRectEqualToRect(_lastFrame, self.view.frame)) {
//    self.boundsDidChange(self.view.bounds);
//    _lastFrame = self.view.frame;
//  }
  
}

@end

@interface RnBsView () <RCTRnBsViewViewProtocol, UISheetPresentationControllerDelegate>
@end

@implementation RnBsView {
  RnBsHostViewController *_viewController;
  RNBSSheetShadowNode::ConcreteState::Shared _state;
  CGSize _oldSize;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    // @TODO: check if this is correct
    _props = RNBSSheetShadowNode::defaultSharedProps();
    _isPresented = NO;
    _viewController = [[RnBsHostViewController alloc] init];
    
    id __weak weakSelf = self;
    _viewController.boundsDidChange = ^(CGRect newBounds) {
        [weakSelf boundsDidChange:newBounds];
    };
  }
  
  return self;
}

+ (void)load
{
  [super load];
}

-(void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  UIView *_view = _viewController.view;
  
  if ([childComponentView isMemberOfClass:RCTViewComponentView.class] || [childComponentView isMemberOfClass:UIView.class]) {
    childComponentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  }
  
  [_view insertSubview:childComponentView atIndex:index];
}

-(void)unmountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  [childComponentView removeFromSuperview];
}

- (void)updateProps:(Props::Shared const &)props
           oldProps:(Props::Shared const &)oldProps {
  const auto &oldViewProps =
      *std::static_pointer_cast<RnBsViewProps const>(_props);
  
  const auto &newViewProps =
      *std::static_pointer_cast<RnBsViewProps const>(props);
  
  [self setShouldPresent:newViewProps.open];
  [self setExpandOnScroll:newViewProps.expandOnScroll];
  [self setDetents: [self parseDetents:newViewProps.detents]];
  [self setLargestUndimmedDetent: [self parseDetent:newViewProps.largestUndimmedDetent]];
  [self setCornerRadius:newViewProps.cornerRadius];
  [self setGrabberVisible:newViewProps.grabberVisible];
  
  [self presentOrCloseBottomSheetIfNeeded];

  [super updateProps:props oldProps:oldProps];
}

- (void)updateState:(const facebook::react::State::Shared &)state
           oldState:(const facebook::react::State::Shared &)oldState
{
  _state = std::static_pointer_cast<const RNBSSheetShadowNode::ConcreteState>(state);
}

- (void)didMoveToWindow
{
  [super didMoveToWindow];
  [self presentOrCloseBottomSheetIfNeeded];
}

- (void)didMoveToSuperview
{
  [super didMoveToSuperview];
  [self presentOrCloseBottomSheetIfNeeded];
}

//- (void)resizeView
//{
//    CGSize newSize = [[_viewController.view.layer.presentationLayer valueForKeyPath:@"frame.size"] CGSizeValue];
//    if (!CGSizeEqualToSize(_oldSize, newSize) && _state != nullptr) {
//        _oldSize = newSize;
//        auto newState = RNBSSheetState{RCTSizeFromCGSize(newSize)};
//        _state->updateState(std::move(newState));
//    }
//}

-(void)presentOrCloseBottomSheetIfNeeded
{
  // Configure sheet -- maybe move to its own thing
  UISheetPresentationController *sheet = _viewController.sheetPresentationController;
  sheet.delegate = self;
  
  [sheet animateChanges:^{
    sheet.detents = _detents;
    sheet.largestUndimmedDetentIdentifier = _largestUndimmedDetent;
    sheet.prefersScrollingExpandsWhenScrolledToEdge = _expandOnScroll;
    sheet.preferredCornerRadius = _cornerRadius;
    sheet.prefersGrabberVisible = _grabberVisible;
    
    // @TODO: more props
    //  sheet.prefersEdgeAttachedInCompactHeight = true;
    //  sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true;
  }];
  
  if (!_isPresented && _shouldPresent && self.window) {
    _isPresented = YES;
    
    UIViewController *controller = [self reactViewController];
    [controller presentViewController:_viewController animated:true completion:nil];
  } else if (_isPresented && !_shouldPresent) {
    _isPresented = NO;
    
    [_viewController dismissViewControllerAnimated:true completion:nil];
  }
}

-(UIViewController *)reactViewController
{
  id responder = [self nextResponder];
  while (responder) {
    if ([responder isKindOfClass:[UIViewController class]]) {
      return responder;
    }
    responder = [responder nextResponder];
  }
  return nil;
}

-(NSArray<UISheetPresentationControllerDetent *> *)parseDetents:(std::vector<std::string>)detents
{
  // @TODO: figure out a better way
  NSMutableArray<UISheetPresentationControllerDetent *> *parsedDetents = [[NSMutableArray alloc] init];
  
  for (const std::string& detent : detents) {
    if (detent.compare("medium") == 0)
    {
      [parsedDetents addObject:UISheetPresentationControllerDetent.mediumDetent];
    }
    
    if (detent.compare("large") == 0)
    {
      [parsedDetents addObject:UISheetPresentationControllerDetent.largeDetent];
    }
  }
  
  return parsedDetents;
}

-(UISheetPresentationControllerDetentIdentifier)parseDetent:(std::string)detent
{
  if (detent.compare("medium") == 0) {
    return UISheetPresentationControllerDetentIdentifierMedium;
  }
  
  if (detent.compare("large") == 0) {
    return UISheetPresentationControllerDetentIdentifierLarge;
  }
  
  return nil;
}

-(void)boundsDidChange:(CGRect)newBounds
{
  if (_state != nullptr) {
    auto newState = RNBSSheetState{RCTSizeFromCGSize(newBounds.size)};
    _state->updateState(std::move(newState));
  }
}

#pragma mark - UISheetPresentationControllerDelegate

- (void)sheetPresentationControllerDidChangeSelectedDetentIdentifier:(UISheetPresentationController *)sheetPresentationController
{
  NSLog(@"DETENT CHANGE : %@", sheetPresentationController.selectedDetentIdentifier);
}

- (void)presentationControllerWillDismiss:(UIPresentationController *)presentationController
{
  auto newState = RNBSSheetState{RCTSizeFromCGSize(CGSize(0))};
  _state->updateState(std::move(newState));
}

// @TODO: figure out if we should use DidDismiss or WillDismiss
- (void)presentationControllerDidDismiss:(UIPresentationController *)presentationController
{
  RnBsViewEventEmitter::OnOpenChange value = RnBsViewEventEmitter::OnOpenChange{.open = NO};
  [self eventEmitter].onOpenChange(value);
}

- (const RnBsViewEventEmitter &)eventEmitter
{
  return static_cast<const RnBsViewEventEmitter &>(*_eventEmitter);
}

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RNBSSheetComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RnBsViewCls(void) { return RnBsView.class; }

@end
