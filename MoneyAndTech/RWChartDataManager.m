//
//  RWChartDataManager.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/9/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartDataManager.h"
#import "RWChart.h"


#define MARKET_PRICE_USD_TITLE @"Market Price (USD)"
#define MARKET_PRICE_USD_URL [NSURL URLWithString:@"https://blockchain.info/charts/market-price?format=json"]

#define NUMBER_OF_TRANSACTIONS_PER_DAY_URL [NSURL URLWithString:@"https://blockchain.info/charts/n-transactions?format=json"]
#define NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE @"Transactions Per Day"

#define NUMBER_OF_CHARTS 2

#define CURRENT_PRICE @"https://blockchain.info/ticker"

@implementation RWChartDataManager

+(RWChartDataManager*) sharedChartDataManager {
    
    static RWChartDataManager* _sharedChartDataManager;
    if(!_sharedChartDataManager) {
        _sharedChartDataManager = [self new];
        _sharedChartDataManager.charts = [[NSMutableArray alloc] init];
    }
    return _sharedChartDataManager;
}

-(void) retrieveData {
    
    NSLog(@"start load chart");
    RWChart* marketPriceUSDChart = [[RWChart alloc] initWithTitle:MARKET_PRICE_USD_TITLE URL:MARKET_PRICE_USD_URL];
    marketPriceUSDChart.labelPrefix = @"$";
    marketPriceUSDChart.successBlock = ^(RWChart* chart){
        [self addChart:chart];
    };
    RWChart* numberOfTransactionsPerDayChart = [[RWChart alloc] initWithTitle:NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE URL:NUMBER_OF_TRANSACTIONS_PER_DAY_URL];
    numberOfTransactionsPerDayChart.labelPrefix = @"";
    numberOfTransactionsPerDayChart.successBlock = ^(RWChart* chart){
        [self addChart:chart];
    };
    
    AFHTTPRequestOperation* marketPriceUSDOperation = [self dataRequestOperationForChart:marketPriceUSDChart];
    AFHTTPRequestOperation* numberOfTransactionsPerDayOperation = [self dataRequestOperationForChart:numberOfTransactionsPerDayChart];
    [numberOfTransactionsPerDayOperation addDependency:marketPriceUSDOperation];
    [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager].operationQueue addOperations:@[marketPriceUSDOperation,numberOfTransactionsPerDayOperation ] waitUntilFinished:NO];
}


-(AFHTTPRequestOperation*) dataRequestOperationForChart:(RWChart*)chart {
    NSURLRequest* chartURLRequest= [[NSURLRequest alloc] initWithURL:chart.url];
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:chartURLRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        chart.chartRawValues = (NSArray*)responseObject[@"values"];
        [chart setupChartData];
        [[RWChartDataManager sharedChartDataManager] addChart:chart];;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@", error);
    }];
    return operation;
}

-(void) addChart:(RWChart*)chart {
    [self.charts addObject:chart];
    if ([self.charts count] == NUMBER_OF_CHARTS) {
        [self.delegate didFinishDownloadingChartData];
    }
}


@end
