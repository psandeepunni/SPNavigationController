//
//  SPChildViewController.m
//  SPNavigationController
//
//  Created by Sandeep Unni on 20/04/14.
//  Copyright (c) 2014 psandeepu. All rights reserved.
//

#import "SPChildViewController.h"

@interface SPChildViewController ()

@property (nonatomic,strong) UIColor *backgroundColor;

@end

@implementation SPChildViewController

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
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:self.backgroundColor];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (id)initWithBackgroundColor:(UIColor*)color {
    
    self = [super initWithNibName:@"SPChildViewController" bundle:nil];
    if (self) {
        self.backgroundColor = color;
    }
    
    return self;
}

- (IBAction)backButtonPressed:(id)sender {
    [self.spNavigationController popViewControllerAnimated:YES];
}

@end
