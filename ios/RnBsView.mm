#import "RnBsView.h"

#import <React/RCTLog.h>
#import <React/RCTSurfaceTouchHandler.h>

#import <react/renderer/components/RnBsViewSpec/ComponentDescriptors.h>
#import <react/renderer/components/RnBsViewSpec/EventEmitters.h>
#import <react/renderer/components/RnBsViewSpec/Props.h>
#import <react/renderer/components/RnBsViewSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface RnBsHostViewController: UIViewController
@end

@implementation RnBsHostViewController {
  RCTSurfaceTouchHandler *_touchHandler;
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
  self.view = [UIView new];
  [_touchHandler attachToView:self.view];
}
@end

@interface RnBsView () <RCTRnBsViewViewProtocol>
@end

@implementation RnBsView {
  UIViewController *_viewController;
  BOOL _shouldPresent;
  BOOL _isPresented;
}

- (instancetype)init
{
  if (self = [super init]) {
    // @TODO: check if this is correct
    _props = RnBsViewShadowNode::defaultSharedProps();
    _isPresented = NO;
    _viewController = [RnBsHostViewController new];
  }
  
  return self;
}

- (void)layoutSubviews
{
  self.frame = CGRectZero;
}

-(void)mountChildComponentView:(UIView<RCTComponentViewProtocol> *)childComponentView index:(NSInteger)index
{
  UIView *_view = _viewController.view;
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

  _shouldPresent = newViewProps.open;
  [self presentOrCloseBottomSheetIfNeeded];

  [super updateProps:props oldProps:oldProps];
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

-(void)presentOrCloseBottomSheetIfNeeded
{
  // Configure sheet -- maybe move to its own thing
  UISheetPresentationController *sheet = _viewController.sheetPresentationController;
  sheet.detents = @[UISheetPresentationControllerDetent.mediumDetent, UISheetPresentationControllerDetent.largeDetent];
  sheet.largestUndimmedDetentIdentifier = UISheetPresentationControllerDetentIdentifierMedium;
  sheet.prefersScrollingExpandsWhenScrolledToEdge = false;
  sheet.prefersEdgeAttachedInCompactHeight = true;
  sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true;
  
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

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<RnBsViewComponentDescriptor>();
}

Class<RCTComponentViewProtocol> RnBsViewCls(void) { return RnBsView.class; }

@end
