//
//  RWChartViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartsViewController.h"
#import "LCLineChartView.h"
#import "RWChartDataItem.h"
#import <AFNetworking/AFNetworking.h>
#import "RWAFHTTPRequestOperationManager.h"
#import "RWChart.h"
#import "RWChartDataManager.h"


@interface RWChartsViewController ()

@property (nonatomic, strong) LCLineChartView* chartView;
@property (nonatomic, strong) RWChart* currentChart;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation RWChartsViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Charts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupActivityIndicator];
    [RWChartDataManager sharedChartDataManager].delegate = self;
    [[RWChartDataManager sharedChartDataManager] retrieveData];
}
-(void) setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
}

#pragma mark retrieve data

-(void) didFinishDownloadingChartData {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[0];
    [self setupStatisticsView];
    [self setupChartView];
    [self.activityIndicator stopAnimating];
}

#pragma mark - statistics view
-(void) setupStatisticsView {
    UIView* statisticsView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 100)];
    
    UILabel* currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [currentPriceLabel setText:[RWChartDataManager sharedChartDataManager].currentPrice];
    [currentPriceLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:36.0]];
    [currentPriceLabel setTextColor:[UIColor blueColor]];
    
    UILabel* marketCapLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 190, 20)];
    [marketCapLabel setText:[NSString stringWithFormat:@"Market cap: %@",[RWChartDataManager sharedChartDataManager].marketCap]];
    [marketCapLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [marketCapLabel setTextColor:[UIColor blueColor]];
    
    UILabel* tradeVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 24, 190, 20)];
    [tradeVolumeLabel setText:[NSString stringWithFormat:@"Trade volume: %@",[RWChartDataManager sharedChartDataManager].tradeVolume]];
    [tradeVolumeLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [tradeVolumeLabel setTextColor:[UIColor blueColor]];
    
    UILabel* hashRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 48, 190, 20)];
    [hashRateLabel setText:[NSString stringWithFormat:@"Hash rate: %@",[RWChartDataManager sharedChartDataManager].hashRate]];
    [hashRateLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [hashRateLabel setTextColor:[UIColor blueColor]];
    
    UILabel* blockRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 72, 190, 20)];
    [blockRateLabel setText:[NSString stringWithFormat:@"Block Time: %@",[RWChartDataManager sharedChartDataManager].blockTime]];
    [blockRateLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [blockRateLabel setTextColor:[UIColor blueColor]];
    
    [statisticsView addSubview:currentPriceLabel];
    [statisticsView addSubview:marketCapLabel];
    [statisticsView addSubview:tradeVolumeLabel];
    [statisticsView addSubview:hashRateLabel];
    [statisticsView addSubview:blockRateLabel];
    [self.view addSubview:statisticsView];
}

#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];

    [self updateChartData];

    [self.view addSubview:self.chartView];
    [self addAlternateDataPeriodButtons];
    [self addAlternateChartButtons];

}

-(void) updateChartData {
    self.chartView.yMax = self.currentChart.yMax;
    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.data = @[self.currentChart.lineChartData];
}

-(void) switchCharts:(UIButton*)sender {
    NSLog(@"Switch charts to %d", sender.tag);
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[sender.tag];
    [self updateChartData];
}

-(void) addAlternateDataPeriodButtons {
    
}

-(void) addAlternateChartButtons {
    UIButton* marketPriceButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.chartView.frame.origin.y + self.chartView.frame.size.height, 180, 44)];
    [marketPriceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [marketPriceButton setTitle:@"Market Price" forState:UIControlStateNormal];
    marketPriceButton.tag = 0;
    [marketPriceButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marketPriceButton];
    
    UIButton* numberOfTransactionsPerDayButton = [[UIButton alloc] initWithFrame:CGRectMake(20, marketPriceButton.frame.origin.y + marketPriceButton.frame.size.height, 180, 44)];
    [numberOfTransactionsPerDayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [numberOfTransactionsPerDayButton setTitle:@"Transactions Per Day" forState:UIControlStateNormal];
    numberOfTransactionsPerDayButton.tag = 1;
    [numberOfTransactionsPerDayButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:numberOfTransactionsPerDayButton];
}


@end
