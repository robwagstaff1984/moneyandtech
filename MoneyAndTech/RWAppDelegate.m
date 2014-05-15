//
//  RWAppDelegate.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWAppDelegate.h"
#import "RWNavigationController.h"
#import <Parse/Parse.h>
#import "RWConfiguration.h"
#import "AKTabBarController.h"
#import "RWArticlesViewController.h"
#import "RWNewsViewController.h"
#import "RWVideosViewController.h"
#import "RWForumViewController.h"
#import "RWChartsViewController.h"
#import "RWPriceViewController.h"

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = MONEY_AND_TECH_GREY;
    [self.window makeKeyAndVisible];
    [[RWConfiguration sharedConfiguration] setupParse];
    [self.window setRootViewController:[self createRootViewController]];
    
    return YES;
}

-(UIViewController*) createRootViewController {
    
    RWNavigationController *navigationController = [[RWNavigationController alloc] initWithRootViewController:[self setupAKTabBarController]];
    
    
    return navigationController;
}

-(AKTabBarController*) setupAKTabBarController {
    AKTabBarController* akTabBarController = [[AKTabBarController alloc] initWithTabBarHeight:TAB_BAR_HEIGHT];
    
    [akTabBarController setViewControllers:[self moneyAndTechViewControllers]];
    
    [akTabBarController setBackgroundImageName:@"noise-light-gray.png"];
    [akTabBarController setSelectedBackgroundImageName:@"noise-dark-blue.png"];
    
    UIColor* tabIconColor = [UIColor colorWithRed:1 green:1.0 blue:1.0 alpha:0.0];
    
    [akTabBarController setIconColors:@[tabIconColor, tabIconColor]];
    [akTabBarController setTabColors:@[[UIColor colorWithRed:1 green:0.1 blue:0.1 alpha:0.0], [UIColor colorWithRed:0 green:0.6 blue:0.6 alpha:0.0]]];
    
    [akTabBarController setTextColor:[UIColor blackColor]];
    [akTabBarController setTextFont:[UIFont fontWithName:@"OCR A Extended" size:11.0]];
    return akTabBarController;
    
}

-(NSMutableArray*) moneyAndTechViewControllers {
    RWVideosViewController* videosViewController = [[RWVideosViewController alloc] init];
    RWArticlesViewController *articlesViewController= [[RWArticlesViewController alloc] init];
    RWNewsViewController *newsViewController= [[RWNewsViewController alloc] init];
    RWChartsViewController *chartsViewController= [[RWChartsViewController alloc] init];
    RWPriceViewController *priceViewController = [[RWPriceViewController alloc] init];
    
    videosViewController.view = videosViewController.view;
    articlesViewController.view = articlesViewController.view;
    newsViewController.view = newsViewController.view;
    priceViewController.view = priceViewController.view;
    chartsViewController.view = chartsViewController.view;
    
    return [NSMutableArray arrayWithObjects:videosViewController, articlesViewController, newsViewController, priceViewController, chartsViewController, nil];
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
