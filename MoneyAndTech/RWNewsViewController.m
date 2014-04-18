//
//  RWNewsViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWNewsViewController.h"
#define NEWS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/news", MONEY_AND_TECH_HOME_PAGE_URL]]

@interface RWNewsViewController ()

@end

@implementation RWNewsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"News";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    return NEWS_URL;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end
