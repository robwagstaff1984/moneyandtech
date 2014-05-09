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

#define MARKET_PRICE_USD_TITLE @"Market Price (USD)"
#define MARKET_PRICE_USD_URL [NSURL URLWithString:@"https://blockchain.info/charts/market-price?format=json"]

#define NUMBER_OF_TRANSACTIONS_PER_DAY_URL [NSURL URLWithString:@"https://blockchain.info/charts/n-transactions?format=json"]
#define NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE @"Transactions Per Day"

#define NUMBER_OF_CHARTS 2

@interface RWChartsViewController ()

@property (nonatomic, strong) LCLineChartView* chartView;
@property (nonatomic, strong) RWChart* currentChart;

@end

@implementation RWChartsViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Charts";
        self.charts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveData];
}
#pragma mark retrieve data
-(void) retrieveData {

    NSLog(@"start load chart");
    RWChart* marketPriceUSDChart = [[RWChart alloc] initWithTitle:MARKET_PRICE_USD_TITLE URL:MARKET_PRICE_USD_URL];
    marketPriceUSDChart.labelPrefix = @"$";
    marketPriceUSDChart.successBlock = ^{
        [self addChart:marketPriceUSDChart];
    };
    RWChart* numberOfTransactionsPerDayChart = [[RWChart alloc] initWithTitle:NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE URL:NUMBER_OF_TRANSACTIONS_PER_DAY_URL];
    numberOfTransactionsPerDayChart.labelPrefix = @"";
    numberOfTransactionsPerDayChart.successBlock = ^{
        [self addChart:numberOfTransactionsPerDayChart];
    };
    
    AFHTTPRequestOperation* marketPriceUSDOperation = marketPriceUSDChart.dataRequestOperation;
    AFHTTPRequestOperation* numberOfTransactionsPerDayOperation = numberOfTransactionsPerDayChart.dataRequestOperation;
    [numberOfTransactionsPerDayOperation addDependency:marketPriceUSDOperation];
    [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager].operationQueue addOperations:@[marketPriceUSDOperation,numberOfTransactionsPerDayOperation ] waitUntilFinished:NO];
}

-(void) addChart:(RWChart*)chart {
    [self.charts addObject:chart];
    if ([self.charts count] == NUMBER_OF_CHARTS) {
        self.currentChart = self.charts[0];
        [self setupChartView];
    }
}


#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];

    [self updateChartData];

    [self.view addSubview:self.chartView];
    [self addAlternateChartButtons];
}

-(void) updateChartData {
    self.chartView.yMax = self.currentChart.yMax;
    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.data = @[self.currentChart.lineChartData];
}

-(void) switchCharts:(UIButton*)sender {
    NSLog(@"Switch charts to %d", sender.tag);
    self.currentChart = self.charts[sender.tag];
    [self updateChartData];
}


-(void) addAlternateChartButtons {
    UIButton* marketPriceButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.chartView.frame.origin.y + self.chartView.frame.size.height + 40, 150, 44)];
    [marketPriceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [marketPriceButton setTitle:@"Market Price" forState:UIControlStateNormal];
    marketPriceButton.tag = 0;
    [marketPriceButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marketPriceButton];
    
    UIButton* numberOfTransactionsPerDayButton = [[UIButton alloc] initWithFrame:CGRectMake(20, marketPriceButton.frame.origin.y + marketPriceButton.frame.size.height + 40, 180, 44)];
    [numberOfTransactionsPerDayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [numberOfTransactionsPerDayButton setTitle:@"Transactions Per Day" forState:UIControlStateNormal];
    numberOfTransactionsPerDayButton.tag = 1;
    [numberOfTransactionsPerDayButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:numberOfTransactionsPerDayButton];
}


@end
