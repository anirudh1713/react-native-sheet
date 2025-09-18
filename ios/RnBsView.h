#import <React/RCTViewComponentView.h>
#import <UIKit/UIKit.h>

#ifndef RnBsViewNativeComponent_h
#define RnBsViewNativeComponent_h

NS_ASSUME_NONNULL_BEGIN

@interface RnBsView : RCTViewComponentView

@property (nonatomic) BOOL shouldPresent;
@property (nonatomic) BOOL isPresented;

@property (nonatomic) UISheetPresentationControllerDetentIdentifier largestUndimmedDetent;
@property (nonatomic) NSArray<UISheetPresentationControllerDetent *> * detents;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) BOOL expandOnScroll;
@property (nonatomic) BOOL grabberVisible;

@end

NS_ASSUME_NONNULL_END

#endif /* RnBsViewNativeComponent_h */
