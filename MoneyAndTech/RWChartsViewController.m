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

#define MARKET_PRICE_USD_TITLE @"MARKET PRICE (USD)"
#define MARKET_PRICE_USD_URL [NSURL URLWithString:@"https://blockchain.info/charts/market-price?format=json"]

#define NUMBER_OF_TRANSACTIONS_PER_DAY_URL [NSURL URLWithString:@"https://blockchain.info/charts/n-transactions?format=json"]
#define NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE @"NUMBER OF TRANSACTIONS_PER_DAY"

#define NUMBER_OF_CHARTS 2

@interface RWChartsViewController ()

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
    marketPriceUSDChart.successBlock = ^{
        [self addChart:marketPriceUSDChart];
    };
    RWChart* numberOfTransactionsPerDayChart = [[RWChart alloc] initWithTitle:NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE URL:NUMBER_OF_TRANSACTIONS_PER_DAY_URL];
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
        [self setupChartView];
    }
}


//#pragma mark - chart view
-(void) setupChartView {

//    int roundedMaxPrice = 100*(([[self maxPrice] intValue]+50)/100);
    int roundedMaxPrice = 100*(([[((RWChart*)self.charts[0]) maxPrice] intValue]+50)/100);
    float roundedQuarterPrice = roundedMaxPrice * 0.25;
    float roundedHalfPrice = roundedMaxPrice * 0.5;
    float roundedThreeQuarterPrice = roundedMaxPrice * 0.75;
    float roundedFiveQuarterPrice = roundedMaxPrice * 1.25;
    
    LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    chartView.yMin = 0;
    chartView.yMax = roundedFiveQuarterPrice;
    
    chartView.ySteps = @[@"$0",[NSString stringWithFormat:@"$%.0f", roundedQuarterPrice], [NSString stringWithFormat:@"$%.0f", roundedHalfPrice], [NSString stringWithFormat:@"$%.0f", roundedThreeQuarterPrice], [NSString stringWithFormat:@"$%d", roundedMaxPrice], [NSString stringWithFormat:@"$%.0f", roundedFiveQuarterPrice]];
    chartView.data = @[((RWChart*)self.charts[0]).lineChartData];
    chartView.drawsDataPoints = NO;
    chartView.axisLabelColor = [UIColor blackColor];
    
    [self.view addSubview:chartView];
}



@end
