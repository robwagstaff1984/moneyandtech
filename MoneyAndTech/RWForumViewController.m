//
//  RWForumViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWForumViewController.h"

#define FORUM_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/forum", [RWConfiguration sharedConfiguration].homeURL]]

@interface RWForumViewController ()

@end

@implementation RWForumViewController

- (id)init
{
    self = [super init];
    if (self) {
         self.title = @"Forum";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    return FORUM_URL;
}

-(BOOL) shouldStripDownWebSection {
    return NO;
}

-(NSURL*) urlForNextPage {
    return FORUM_URL;
}

-(NSString*) strippedHTMLFromData:(NSData*)htmlData {
    return [RWXPathStripper strippedHtmlFromForumHTML:htmlData];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityLow;
}

- (NSString *)tabImageName
{
    return @"ForumIcon";
}

- (NSString *)tabTitle
{
    return @"Forum";
}

@end
