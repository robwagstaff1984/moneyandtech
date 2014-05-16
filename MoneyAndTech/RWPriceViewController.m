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
#import "RWConfiguration.h"

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
    if (![RWConfiguration sharedConfiguration].shouldShowChartsPage) {
        [[RWChartDataManager sharedChartDataManager] retrieveData];
    }
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
        
        CGRect frameInsideTabBarController =  CGRectMake(0, NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
        
        self.statisticsView = [[RWStatisticsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT)];
        self.scrollView = [[UIScrollView alloc] initWithFrame:frameInsideTabBarController];
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
    [scrollView.pullToRefreshView stopAnimating];
}

- (NSString *)tabImageName
{
    return @"PriceIcon";
}

- (NSString *)tabTitle
{
    return @"Price";
}

@end
