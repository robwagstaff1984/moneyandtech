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

#define MONEY_AND_TECH_GREY [UIColor colorWithRed:247.0/255.0 green:249.0/255.0 blue:246/255.0 alpha:1]

@interface RWNavigationController ()

@end

@implementation RWNavigationController

- (id)init
{
    self = [super init];
    if (self) {
        [self setupNavigationView];
    }
    return self;
}

-(void) setupNavigationView {
    [self.navigationBar setBarTintColor:MONEY_AND_TECH_GREY];
    [self.navigationBar setTranslucent:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
