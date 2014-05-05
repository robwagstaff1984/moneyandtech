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
#import <Parse/Parse.h>
#import "RWConfiguration.h"

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [[RWConfiguration sharedConfiguration] setupParse];
    [self.window setRootViewController:[self createRootViewController]];
    
    return YES;
}

-(UIViewController*) createRootViewController {
    RWTabBarController* tabBarController = [[RWTabBarController alloc] init];
    [tabBarController setEdgesForExtendedLayout:UIRectEdgeBottom];
    RWNavigationController *navigationController = [[RWNavigationController alloc] initWithRootViewController:tabBarController];\
    return navigationController;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

@end
