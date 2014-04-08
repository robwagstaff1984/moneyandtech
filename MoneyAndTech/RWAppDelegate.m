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

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupParse];
    RWTabBarController* tabBarController = [[RWTabBarController alloc] init];
    RWNavigationController *navigationController = [[RWNavigationController alloc] initWithRootViewController:tabBarController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:navigationController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void) setupParse {
    [Parse setApplicationId:@"sfgZq1Me3Z6AXgVktP3Yb6RFaW0AhxwI3Yv9wtk8" clientKey:@"IAhDDnpjSOvb2tu6UneXvwhDV9Yz5tObRxHhThmB"];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
