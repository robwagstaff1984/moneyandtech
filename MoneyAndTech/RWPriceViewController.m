//
//  RWPriceViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPriceViewController.h"
#import "RWStatisticsView.h"
#import "UIScrollView+S"

@implementation RWPriceViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Price";
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownloadingChartData) name:BITCOIN_STATISTICS_DOWNLOADED object:nil];
    [self startSpinner];
}

-(void) didFinishDownloadingChartData {
    NSLog(@"didFinishDownloadingChartData Price;\n");
    [self setupStatisticsView];
    [self stopSpinner];
}

#pragma mark - statistics view
-(void) setupStatisticsView {
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 300)];
    scrollView.backgroundColor = [UIColor redColor];
    scrollView.userInteractionEnabled = YES;
    scrollView.alwaysBounceVertical = YES;
    
    RWStatisticsView* statisticsView = [[RWStatisticsView alloc] initWithFrame:self.view.frame];
    [scrollView addSubview:statisticsView];
    
    [scrollView addPullToRefreshWithActionHandler];
    
    [scrollView addInfiniteScrollingWithActionHandler:^{
        [self didTriggerRefresh];
    } forPosition:SVInfiniteScrollingPositionBottom];
    
    [self.view addSubview:scrollView];
    
}


-(void)didTriggerRefresh {
    NSLog(@"refrest");
}

@end
