//
//  RWPriceViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPriceViewController.h"
#import "RWStatisticsView.h"

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
    RWStatisticsView* statisticsView = [[RWStatisticsView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:statisticsView];
}

@end
