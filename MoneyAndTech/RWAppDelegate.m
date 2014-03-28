//
//  RWAppDelegate.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWAppDelegate.h"
#import "RWArticlesViewController.h"
#import "RWNewsViewController.h"
#import "RWVideosViewController.h"
#import "RWHomeViewController.h"

#define MONEY_AND_TECH_GREY [UIColor colorWithRed:247.0/255.0 green:249.0/255.0 blue:246/255.0 alpha:1]

@implementation RWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor grayColor];
    
    RWVideosViewController* videosViewController = [[RWVideosViewController alloc] init];

    RWArticlesViewController *articlesViewController= [[RWArticlesViewController alloc] init];
    RWNewsViewController *newsViewController= [[RWNewsViewController alloc] init];
    UITabBarController* tabBarController = [[UITabBarController alloc] init];
    tabBarController.title = @"Money And Tech";
    
    UIImage *videosImage = [UIImage imageNamed:@"VideosIcon.png"];
    UIImage *videosImageSel = [UIImage imageNamed:@"VideosIcon.png"];
    
    videosImage = [videosImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    videosImageSel = [videosImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    videosViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Videos" image:videosImage selectedImage:videosImageSel];
    
    
    
    UIImage *articlesImage = [UIImage imageNamed:@"ArticlesIcon.png"];
    UIImage *articlesImageSel = [UIImage imageNamed:@"ArticlesIcon.png"];
    
    articlesImage = [articlesImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    articlesImageSel = [articlesImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    articlesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Articles" image:articlesImage selectedImage:articlesImageSel];
    
    
    UIImage *newsImage = [UIImage imageNamed:@"NewsIcon.png"];
    UIImage *newsImageSel = [UIImage imageNamed:@"NewsIcon.png"];
    
    newsImage = [newsImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newsImageSel = [newsImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    newsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News" image:newsImage selectedImage:newsImageSel];
    
    
    tabBarController.viewControllers = @[videosViewController, articlesViewController, newsViewController];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    
    
    [self.window setRootViewController:navigationController];
    

    
    [self.window makeKeyAndVisible];
    
    [navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:247.0/255.0 green:249.0/255.0 blue:246/255.0 alpha:1]];
    [navigationController.navigationBar setTranslucent:NO];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
