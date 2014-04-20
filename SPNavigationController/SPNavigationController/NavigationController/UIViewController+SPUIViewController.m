//
//  UIViewController+SPUIViewController.m
//
//
//  Created by Sandeep Unni on 15/10/12.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import "UIViewController+SPUIViewController.h"

@implementation UIViewController (SLUIViewController)

- (SPNavigationController*)spNavigationController
{
    UIViewController *controller = self.parentViewController;
    
    while (controller && ![controller isKindOfClass:[SPNavigationController class]]) {
        controller = [controller parentViewController];
    }
    
    return  (SPNavigationController*)controller;
}

@end
