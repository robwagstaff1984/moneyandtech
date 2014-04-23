//
//  RWNavigationController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWNavigationController.h"
#import "RWVideosViewController.h"
#import "RWArticlesViewController.h"
#import "RWNewsViewController.h"


@interface RWNavigationController ()

@end

@implementation RWNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setupNavigationView];
    }
    return self;
}

-(void) setupNavigationView {
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"OCR A Extended" size:20.0], NSForegroundColorAttributeName: [UIColor blackColor]};
    [self.navigationBar setBarTintColor:NAV_BAR_GREY];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
