//
//  RWAppDelegate.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWAppDelegate.h"
#import "RWNavigationController.h"
#import "RWTabBarController.h"

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    RWTabBarController* tabBarController = [[RWTabBarController alloc] init];
    RWNavigationController *navigationController = [[RWNavigationController alloc] initWithRootViewController:tabBarController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
