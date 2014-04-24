//
//  RWTabBarController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWTabBarController.h"
#import "RWArticlesViewController.h"
#import "RWNewsViewController.h"
#import "RWVideosViewController.h"
#import "RWForumViewController.h"

@interface RWTabBarController ()

@end

@implementation RWTabBarController

- (id)init
{
    self = [super init];
    if (self) {
        [self setupTabBarController];
    }
    return self;
}

-(void) setupTabBarController {
    self.title = @"MONEY & TECH";
    [self setupTabBarAppearance];
    [self addWebSectionViewControllersToTabBar];
}

-(void) setupTabBarAppearance {
    [self.tabBar setBarTintColor:NAV_BAR_GREY];
    [self.tabBar setTintColor:[UIColor blackColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"OCR A Extended" size:11.0], NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
}

-(void) addWebSectionViewControllersToTabBar {
    RWVideosViewController* videosViewController = [[RWVideosViewController alloc] init];
    RWArticlesViewController *articlesViewController= [[RWArticlesViewController alloc] init];
    RWNewsViewController *newsViewController= [[RWNewsViewController alloc] init];
    RWForumViewController *forumViewController= [[RWForumViewController alloc] init];
    
    [self addTabBarItemToViewController:videosViewController withTitle:@"Videos"];
    [self addTabBarItemToViewController:articlesViewController withTitle:@"Articles"];
    [self addTabBarItemToViewController:newsViewController withTitle:@"News"];
    [self addTabBarItemToViewController:forumViewController withTitle:@"Forum"];
    
    self.viewControllers = @[videosViewController, articlesViewController, newsViewController, forumViewController];
    articlesViewController.view = articlesViewController.view;
    newsViewController.view = newsViewController.view;
    forumViewController.view = forumViewController.view;
}

-(void) addTabBarItemToViewController:(UIViewController*)viewController withTitle:(NSString*)title {
    UIImage *tabBarImage = [UIImage imageNamed:[title stringByAppendingString:@"Icon.png"]];
    UIImage *tabBarImageSel = [UIImage imageNamed:[title stringByAppendingString:@"Icon.png"]];
    
    tabBarImage = [tabBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarImageSel = [tabBarImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:tabBarImage selectedImage:tabBarImageSel];
}



@end
