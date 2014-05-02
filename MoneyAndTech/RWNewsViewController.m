//
//  RWNewsViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWNewsViewController.h"
#define NEWS_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/news", [RWConfiguration sharedConfiguration].homeURL]]
#define NEWS_NEXT_PAGE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/news/page/%d/", [RWConfiguration sharedConfiguration].homeURL, self.pageNumber]]

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
    return [RWConfiguration sharedConfiguration].shouldReformatNewsPage;
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
