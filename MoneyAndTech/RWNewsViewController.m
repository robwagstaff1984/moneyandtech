//
//  RWNewsViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWNewsViewController.h"
#define NEWS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/news", MONEY_AND_TECH_HOME_PAGE_URL]]
#define NEWS_NEXT_PAGE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/news/page/%d/", MONEY_AND_TECH_HOME_PAGE_URL, self.pageNumber]]

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

-(BOOL) shouldStripDownWebSection {
    return NO;
}

-(NSURL*) urlForNextPage {
    return NEWS_NEXT_PAGE_URL;
}

-(NSString*) strippedHTMLFromData:(NSData*)htmlData {
    return [RWXPathStripper strippedHtmlFromNewsHTML:htmlData];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}


@end
