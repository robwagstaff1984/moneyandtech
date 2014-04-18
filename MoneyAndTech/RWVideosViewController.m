//
//  RWVideosViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWVideosViewController.h"

#define VIDEOS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/videos", MONEY_AND_TECH_HOME_PAGE_URL]]
#define VIDEOS_NEXT_PAGE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/videos/page/%d/", MONEY_AND_TECH_HOME_PAGE_URL, self.pageNumber]]

#define JAVASCRIPT_RESTYLE_VIDEOS_PAGE @"document.getElementsByTagName('body')[0].style['visibility']='hidden'; document.getElementsByTagName('article')[0].style['visibility']='visible';"

@interface RWVideosViewController ()

@end

@implementation RWVideosViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Videos";
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    return VIDEOS_URL;
}

-(NSURL*) urlForNextPage {
    return VIDEOS_NEXT_PAGE_URL;
}

-(NSString*) strippedHTMLFromData:(NSData*)htmlData {
    return [RWXPathStripper strippedHtmlFromVideosHTML:htmlData];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end
