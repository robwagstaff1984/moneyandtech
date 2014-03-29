//
//  RWVideosViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWVideosViewController.h"
#import "RWRegexHTMLStripper.h"

#define VIDEOS_URL [NSURL URLWithString:@"http://www.moneyandtech.com/videos"]

#define JAVASCRIPT_RESTYLE_VIDEOS_PAGE @"document.getElementsByTagName('body')[0].style['visibility']='hidden'; document.getElementsByTagName('article')[0].style['visibility']='visible';"

@interface RWVideosViewController ()
@property (nonatomic) BOOL isRestylingDone;

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

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

//
//    NSString* videosPageStrippedJavascript = [RWRegexHTMLStripper videosPageStrippedJavascript];
//    
//    if (!self.isRestylingDone) {
//        self.isRestylingDone = YES;
//        [webView stringByEvaluatingJavaScriptFromString:videosPageStrippedJavascript];
//        NSLog(@"stripping down HTML!");
//    }


@end
