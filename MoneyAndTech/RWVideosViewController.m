//
//  RWVideosViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWVideosViewController.h"

#define VIDEOS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/videos", [RWConfiguration sharedConfiguration].homeURL]]
#define VIDEOS_NEXT_PAGE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/videos/page/%d/", [RWConfiguration sharedConfiguration].homeURL, self.pageNumber]]

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

-(BOOL) shouldStripDownWebSection {
    return [RWConfiguration sharedConfiguration].shouldReformatVideosPage;
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

- (NSString *)tabImageName
{
    return @"VideosIcon";
}

- (NSString *)tabTitle
{
    return @"Videos";
}

@end
