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

- (id)init
{
    self = [super init];
    if (self) {
        [self setupNavigationView];
    }
    return self;
}

-(void) setupNavigationView {
    [self.navigationBar setBarTintColor:[UIColor blueColor]];
    [self.navigationBar setTranslucent:NO];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
