//
//  RWPriceViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPriceViewController.h"
#import "RWStatisticsView.h"
#import "UIScrollView+SVPullToRefresh.h"

@interface RWPriceViewController()
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) RWStatisticsView* statisticsView;
@end

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
    if (!self.scrollView) {
        self.statisticsView = [[RWStatisticsView alloc] initWithFrame:self.view.frame];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        self.scrollView.backgroundColor = MONEY_AND_TECH_GREY;
        self.scrollView.userInteractionEnabled = YES;
        self.scrollView.alwaysBounceVertical = YES;
        [self.scrollView addSubview:self.statisticsView];
        __weak typeof(self) weakSelf = self;
        [self.scrollView addPullToRefreshWithActionHandler:^{
            [weakSelf didTriggerRefresh:weakSelf.scrollView];
        }];
        
        [self.view addSubview:self.scrollView];
    } else {
        [self.statisticsView updatePrice];
    }
}


-(void)didTriggerRefresh:(UIScrollView*)scrollView {
    [[RWChartDataManager sharedChartDataManager] retrieveLatestPrice];
//    self.statisticsView
    [scrollView.pullToRefreshView stopAnimating];
}

@end
