//
//  UIViewController+SPUIViewController.h
//
//  Created by Sandeep Unni on 15/10/12.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPNavigationController.h"

@interface UIViewController (SPUIViewController)

@property (nonatomic, retain, readonly) SPNavigationController *spNavigationController;

@end
