//
//  SPInitialViewController.m
//  SPNavigationController
//
//  Created by Sandeep Unni on 20/04/14.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import "SPInitialViewController.h"
#import "SPChildViewController.h"

@interface SPInitialViewController ()

@end

@implementation SPInitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftToRightButtonPressed:(id)sender {
    SPChildViewController *child = [[SPChildViewController alloc] initWithBackgroundColor:[UIColor redColor]];
    [self.spNavigationController pushViewController:child animated:YES animationType:UITransitionPushFromLeftSide];
}

- (IBAction)rightToLeftButtonPressed:(id)sender {
    
    SPChildViewController *child = [[SPChildViewController alloc] initWithBackgroundColor:[UIColor yellowColor]];
    [self.spNavigationController pushViewController:child animated:YES animationType:UITransitionPushFromRightSide];
    
}

- (IBAction)upToDownButtonPressed:(id)sender {
    
    SPChildViewController *child = [[SPChildViewController alloc] initWithBackgroundColor:[UIColor blueColor]];
    [self.spNavigationController pushViewController:child animated:YES animationType:UITransitionPushFromTop];
}

- (IBAction)downToUpButtonPressed:(id)sender {
    
    SPChildViewController *child = [[SPChildViewController alloc] initWithBackgroundColor:[UIColor greenColor]];
    [self.spNavigationController pushViewController:child animated:YES animationType:UITransitionPushFromBottom];
    
}

@end
