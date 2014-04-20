//
//  SPNavigationController.m
//
//  Created by Sandeep Unni on 13/10/12.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import "SPNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_TIME 0.3

typedef struct {
    CGPoint fromOriginForNewView;
    CGPoint toOriginForNewView;
    CGPoint fromOriginForCurrentView;
    CGPoint toOriginForCurrentView;
}TransitionProperty;

@interface SLStackObject : NSObject

@property (nonatomic, strong) UIViewController *viewController;
@property UITransitionAnimationType transition;

- (id)initWithViewController:(UIViewController *)_viewVC transitionType:(UITransitionAnimationType)_type;

@end

@implementation SLStackObject

@synthesize viewController;
@synthesize transition;

- (id)initWithViewController:(UIViewController *)_viewVC transitionType:(UITransitionAnimationType)_type
{
    self = [super init];
    
    if (self) {
        self.transition = _type;
        self.viewController = _viewVC;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"view controller being released = %@",NSStringFromClass(self.viewController.class));
}

@end

@interface SPNavigationController ()
{
    NSMutableArray *_stackOfViewControllers;
    CATransition *_previousTransition;
    UITransitionAnimationType previousAnimationType;
    
    IBOutlet UIView *collectionGrid;
    IBOutlet UIView *collectionContentView;
    
}

@property (nonatomic, strong) UIViewController *rootViewController;


- (UITransitionAnimationType)reverseTransitionTypeForTransitionKey:(UITransitionAnimationType)_transitionType;
- (TransitionProperty)CATransitionPropertyForTransitionKey:(UITransitionAnimationType)_transitionType;

@end

@implementation SPNavigationController

- (TransitionProperty)CATransitionPropertyForTransitionKey:(UITransitionAnimationType)_transitionType
{
    TransitionProperty property;
    property.fromOriginForCurrentView = CGPointMake(0.0f, 0.0f);
    property.toOriginForNewView = CGPointMake(0.0f, 0.0f);
    
    switch (_transitionType) {
        case UITransitionPushFromBottom:
            property.toOriginForCurrentView = CGPointMake(0.0f, -self.view.frame.size.height);
            property.fromOriginForNewView = CGPointMake(0.0f, self.view.frame.size.height);
            break;
        case UITransitionPushFromTop:
            property.toOriginForCurrentView = CGPointMake(0.0f, self.view.frame.size.height);
            property.fromOriginForNewView = CGPointMake(0.0f, -self.view.frame.size.height);
            break;
        case UITransitionPushFromLeftSide:
            property.toOriginForCurrentView = CGPointMake(self.view.frame.size.width, 0.0f);
            property.fromOriginForNewView = CGPointMake(-self.view.frame.size.width, 0.0f);
            break;
        case UITransitionPushFromRightSide:
            property.toOriginForCurrentView = CGPointMake(-self.view.frame.size.width, 0.0f);
            property.fromOriginForNewView = CGPointMake(self.view.frame.size.width, 0.0f);
            break;
        default:
            property.toOriginForCurrentView = CGPointMake(-self.view.frame.size.width, 0.0f);
            property.fromOriginForNewView = CGPointMake(self.view.frame.size.width, 0.0f);
            break;
    }
    
    return property;
}

- (UITransitionAnimationType)reverseTransitionTypeForTransitionKey:(UITransitionAnimationType)_transitionType
{
    UITransitionAnimationType defaultType = UITransitionPushFromRightSide;
    switch (_transitionType) {
        case UITransitionPushFromBottom:
            defaultType = UITransitionPushFromTop;
            break;
        case UITransitionPushFromTop:
            defaultType = UITransitionPushFromBottom;
            break;
        case UITransitionPushFromLeftSide:
            defaultType = UITransitionPushFromRightSide;
            break;
        case UITransitionPushFromRightSide:
            defaultType = UITransitionPushFromLeftSide;
            break;
        default:
            break;
    }
    
    return defaultType;
}

- (UIView*)navigationBar
{
    return nil;
}

-(SPNavigationController *)myNavigationController
{
    UIViewController *controller = self.parentViewController;
    
    while (controller && ![controller isKindOfClass:[SPNavigationController class]]) {
        controller = [controller parentViewController];
    }
    
    return  (SPNavigationController*)controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    self.viewControllers = [NSArray arrayWithArray:_stackOfViewControllers];
    
    [self addChildViewController:topObject.viewController];
    [self.view addSubview:topObject.viewController.view];
    [topObject.viewController.view setFrame:self.view.bounds];
    [topObject.viewController didMoveToParentViewController:self];
    
}

- (NSArray *)getViewControllers
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SLStackObject *obj in _stackOfViewControllers) {
        [array addObject:obj.viewController];
    }
    return array;
}

- (UIViewController*)getTopViewController
{
    SLStackObject *obj = [_stackOfViewControllers lastObject];
    return obj.viewController;
}

- (UIViewController*)getVisibleViewController
{
    if (self.presentedViewController) {
        return self.presentedViewController;
    }
    
    SLStackObject *obj = [_stackOfViewControllers lastObject];
    
    return obj.viewController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithNibName:@"SPNavigationController" bundle:nil];
    if (self) {
        // Custom initialization
        self.rootViewController = rootViewController;
        SLStackObject *firstObject = [[SLStackObject alloc] initWithViewController:rootViewController transitionType:UITransitionPushFromRightSide];
        _stackOfViewControllers = [[NSMutableArray alloc] initWithObjects:firstObject, nil];
        
    }
    return self;
}


#pragma mark - Instance Methods

- (void)setRootViewControllerTo:(UIViewController*)newRootViewController
{
    self.rootViewController = nil;

    int length = 0;
    
    for (int i = 0; i < _stackOfViewControllers.count; i++) {
        SLStackObject *obj = [_stackOfViewControllers objectAtIndex:i];        
        if (obj.viewController == newRootViewController) {
            break;
        }
        length++;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,length)];
    [_stackOfViewControllers removeObjectsAtIndexes:indexSet];

    self.rootViewController = newRootViewController;
}


- (void)popToRootViewControllerAnimated:(BOOL)animated
{
    
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = (_stackOfViewControllers.count - 1); i >= 1; i--) {
        
        SLStackObject *obj = [_stackOfViewControllers objectAtIndex:i];
        [array addObject:obj];
    }
    
    [_stackOfViewControllers removeObjectsInArray:array];

    [array removeAllObjects];
    
    SLStackObject *rootObj = [_stackOfViewControllers objectAtIndex:0];
    [_stackOfViewControllers addObject:topObject];
    
    if (animated) {
        [self performTransitionFromStackObject:topObject ToStackObject:rootObj key:@"pop" transitionType:topObject.transition];
    } else {
        [self moveFromStackObject:topObject ToStackObject:rootObj];
        [_stackOfViewControllers removeLastObject];

    }
    
    
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    SLStackObject *obj = nil;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = (_stackOfViewControllers.count - 1); i >= 0; i--) {
        
        obj = [_stackOfViewControllers objectAtIndex:i];
        if (obj.viewController == viewController) {
            break;
        }
        
        [array addObject:obj];
    }
    
    [_stackOfViewControllers removeObjectsInArray:array];
    [array removeAllObjects];

    
    [_stackOfViewControllers addObject:topObject];
    
    if (animated) {
        [self performTransitionFromStackObject:topObject ToStackObject:obj key:@"pop" transitionType:topObject.transition];
    } else {
        [self moveFromStackObject:topObject ToStackObject:obj];
        [_stackOfViewControllers removeLastObject];
    }
       
}

- (void)pushViewControllerFinished
{
    SLStackObject *secondLastObject = [_stackOfViewControllers objectAtIndex:(_stackOfViewControllers.count - 2)];
    
    [secondLastObject.viewController.view removeFromSuperview];
    [secondLastObject.viewController removeFromParentViewController];
    
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    [topObject.viewController didMoveToParentViewController:self];
    [topObject.viewController.view setFrame:self.view.bounds];
    
    [self.view setUserInteractionEnabled:YES];
    
}

- (void)popControllerFinished
{
    SLStackObject *TopObject = [_stackOfViewControllers lastObject];
    [TopObject.viewController.view removeFromSuperview];
    [TopObject.viewController removeFromParentViewController];
    
    [_stackOfViewControllers removeLastObject];
    
    SLStackObject *nextTopObject = [_stackOfViewControllers lastObject];
    [nextTopObject.viewController didMoveToParentViewController:self];
    [nextTopObject.viewController.view setFrame:self.view.bounds];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.delegate navigationController:self didShowViewController:nextTopObject.viewController animated:YES];
    }
    
    [self.view setUserInteractionEnabled:YES];
}

- (void)moveFromStackObject:(SLStackObject*)_fromStackObject
              ToStackObject:(SLStackObject*)_toStackObject
{
    [self.view setUserInteractionEnabled:NO];
    [_fromStackObject.viewController willMoveToParentViewController:nil];
    [_fromStackObject.viewController.view removeFromSuperview];
    [_fromStackObject.viewController removeFromParentViewController];
    
    
    [self addChildViewController:_toStackObject.viewController];
    [self.view addSubview:_toStackObject.viewController.view];
    [_toStackObject.viewController.view setFrame:self.view.bounds];
    [_toStackObject.viewController didMoveToParentViewController:self];
    
    [self.view setUserInteractionEnabled:YES];
}

- (void)performTransitionFromStackObject:(SLStackObject*)_fromStackObject
                           ToStackObject:(SLStackObject*)_toStackObject
                                     key:(NSString*)_key
                          transitionType:(UITransitionAnimationType)_type
{
    /*
     
     _fromStackObject contains current visible view
     _toStackObject contains view to be moved in to visibility
     
     */
    
    [self.view setUserInteractionEnabled:NO];
    
    if ([_key isEqualToString:@"push"]) {
        
        TransitionProperty animationProperty = [self CATransitionPropertyForTransitionKey:_type];
        
        [_fromStackObject.viewController.view setFrame:CGRectMake(animationProperty.fromOriginForCurrentView.x,animationProperty.fromOriginForCurrentView.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        //clean up previous view
        
        [_fromStackObject.viewController willMoveToParentViewController:nil];
        
        //Add SLContentViewController view to navigation controller view hierarchy
        [self addChildViewController:_toStackObject.viewController];
        [self.view addSubview:_toStackObject.viewController.view];
        [_toStackObject.viewController.view setFrame:CGRectMake(animationProperty.fromOriginForNewView.x,animationProperty.fromOriginForNewView.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        [UIView beginAnimations:@"push" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:ANIMATION_TIME];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(pushViewControllerFinished)];
        [_fromStackObject.viewController.view setFrame:CGRectMake(animationProperty.toOriginForCurrentView.x,animationProperty.toOriginForCurrentView.y, self.view.frame.size.width, self.view.frame.size.height)];
        [_toStackObject.viewController.view setFrame:CGRectMake(animationProperty.toOriginForNewView.x, animationProperty.toOriginForNewView.y, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
        
    } else if ([_key isEqualToString:@"pop"]) {
        
        TransitionProperty animationProperty = [self CATransitionPropertyForTransitionKey:[self reverseTransitionTypeForTransitionKey:_type]];
        
        [_fromStackObject.viewController.view setFrame:CGRectMake(animationProperty.fromOriginForCurrentView.x,animationProperty.fromOriginForCurrentView.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        //clean up previous view
        
        [_fromStackObject.viewController willMoveToParentViewController:nil];
        
        //Add previous SLContentViewController to navigation controller view hierarchy
        [self addChildViewController:_toStackObject.viewController];
        [self.view addSubview:_toStackObject.viewController.view];
        [_toStackObject.viewController.view setFrame:CGRectMake(animationProperty.fromOriginForNewView.x,animationProperty.fromOriginForNewView.y, self.view.frame.size.width, self.view.frame.size.height)];
        //        [_toStackObject.parentContentController didMoveToParentViewController:self];
        
        
        [UIView beginAnimations:@"pop" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDuration:ANIMATION_TIME];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(popControllerFinished)];
        [_fromStackObject.viewController.view setFrame:CGRectMake(animationProperty.toOriginForCurrentView.x,animationProperty.toOriginForCurrentView.y, self.view.frame.size.width, self.view.frame.size.height)];
        [_toStackObject.viewController.view setFrame:CGRectMake(animationProperty.toOriginForNewView.x, animationProperty.toOriginForNewView.y, self.view.frame.size.width, self.view.frame.size.height)];
        [UIView commitAnimations];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.delegate navigationController:self willShowViewController:_toStackObject.viewController animated:YES];
    }
    
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    SLStackObject *secondLastObject = [_stackOfViewControllers objectAtIndex:(_stackOfViewControllers.count - 2)];
    
    if (animated) {
        [self performTransitionFromStackObject:topObject ToStackObject:secondLastObject key:@"pop" transitionType:topObject.transition];
    } else {
        [self moveFromStackObject:topObject ToStackObject:secondLastObject];
        [_stackOfViewControllers removeLastObject];
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationType:(UITransitionAnimationType)_transition
{
    
    SLStackObject *newObject = [[SLStackObject alloc] initWithViewController:viewController transitionType:_transition];
    SLStackObject *topObject = [_stackOfViewControllers lastObject];
    
    [_stackOfViewControllers addObject:newObject];
    
    
    if (animated) {
        [self performTransitionFromStackObject:topObject ToStackObject:[_stackOfViewControllers lastObject] key:@"push" transitionType:newObject.transition];
    } else {
        [self moveFromStackObject:topObject ToStackObject:[_stackOfViewControllers lastObject]];
    }
    
    return;
}

@end
