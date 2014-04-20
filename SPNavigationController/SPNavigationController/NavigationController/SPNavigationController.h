//
//  SPNavigationController.h
//
//
//  Created by Sandeep Unni on 13/10/12.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UITransitionPushFromBottom,
    UITransitionPushFromTop,
    UITransitionPushFromRightSide,
    UITransitionPushFromLeftSide
}UITransitionAnimationType;

@protocol SPNavigationControllerDelegate <NSObject>

- (void)navigationController:(UIViewController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)navigationController:(UIViewController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

@interface SPNavigationController : UIViewController <UIGestureRecognizerDelegate>

/*
 The nearest ancestor in the view controller hierarchy that is a slnavigation controller.
 
 If the receiver or one of its ancestors is a child of a slnavigation controller, this property contains the owning navigation controller. This property is nil if the view controller is not embedded inside a slnavigation controller.
 */

@property (weak, nonatomic, readonly) SPNavigationController *myNavigationController;

/*
 The navigation bar managed by the navigation controller. (read-only)
 */

@property(weak, nonatomic,readonly) UIView *navigationBar;
/*
 The view controllers currently on the navigation stack.
 */
@property(nonatomic, copy, getter = getViewControllers) NSArray *viewControllers;

/*
 The view controller at the top of the navigation stack. (read-only)
 */
@property(nonatomic, readonly, strong, getter = getTopViewController) UIViewController *topViewController;

/*
 The view controller associated with the currently visible view in the navigation interface. (read-only)
 */
@property(nonatomic, readonly, strong, getter = getVisibleViewController) UIViewController *visibleViewController;

/*
 The receiver’s delegate or nil if it doesn’t have a delegate.
 */
@property(nonatomic, weak) id<SPNavigationControllerDelegate> delegate;

/*
 Initializes and returns a newly created navigation controller.
 
 Parameters
 ==========
 rootViewController
 The view controller that resides at the bottom of the navigation stack. This object cannot be an instance of the UITabBarController class.
 
 Return Value
 ============
 The initialized navigation controller object or nil if there was a problem initializing the object.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)setRootViewControllerTo:(UIViewController*)viewController;

/*
 Pops all the view controllers on the stack except the root view controller and updates the display.
 
 Parameters
 ==========
 animated
 Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 
 Return Value
 ============
 An array of view controllers that are popped from the stack.
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated;

/*
 Pops view controllers until the specified view controller is at the top of the navigation stack.
 Parameters
 ==========
 viewController
 The view controller that you want to be at the top of the stack.
 
 animated
 Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 
 Return Value
 ============
 An array containing the view controllers that were popped from the stack.
 */
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
/*
 Pops the top view controller from the navigation stack and updates the display.
 Parameters
 ==========
 animated
 Set this value to YES to animate the transition. Pass NO if you are setting up a navigation controller before its view is displayed.
 
 Return Value
 ============
 The view controller that was popped from the stack.
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/*
 Pushes a view controller onto the receiver’s stack and updates the display.
 Parameters
 ==========
 viewController
 The view controller that is pushed onto the stack. This object cannot be an instance of tab bar controller and it must not already be on the navigation stack.
 
 animated
 Specify YES to animate the transition or NO if you do not want the transition to be animated. You might specify NO if you are setting up the navigation controller at launch time.
 
 animationType
 A animation type indicating how you want to perform the animations. For a list of valid constants, see UITransitionAnimationType.
 
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationType:(UITransitionAnimationType)_transition;


@end


