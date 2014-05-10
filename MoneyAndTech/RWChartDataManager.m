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

#define STATS_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/stats?format=json"]]
#define MARKET_CAP_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/q/marketcap"]]


#define NUMBER_OF_CHARTS 2

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
    
    RWChart* numberOfTransactionsPerDayChart = [[RWChart alloc] initWithTitle:NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE URL:NUMBER_OF_TRANSACTIONS_PER_DAY_URL];

    AFHTTPRequestOperation* statsOperation = [self dataRequestOperationForStats];
    AFHTTPRequestOperation* marketCapOperation = [self dataRequestOperationForMarketCap];
    AFHTTPRequestOperation* marketPriceUSDOperation = [self dataRequestOperationForChart:marketPriceUSDChart];
    AFHTTPRequestOperation* numberOfTransactionsPerDayOperation = [self dataRequestOperationForChart:numberOfTransactionsPerDayChart];

    [marketCapOperation addDependency:statsOperation];
    [marketPriceUSDOperation addDependency:marketCapOperation];
    [numberOfTransactionsPerDayOperation addDependency:marketPriceUSDOperation];
    [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager].operationQueue addOperations:@[statsOperation, marketCapOperation, marketPriceUSDOperation,numberOfTransactionsPerDayOperation ] waitUntilFinished:NO];
}


-(AFHTTPRequestOperation*) dataRequestOperationForChart:(RWChart*)chart {
    NSURLRequest* chartURLRequest= [[NSURLRequest alloc] initWithURL:chart.url];
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:chartURLRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        chart.chartRawValues = (NSArray*)responseObject[@"values"];
        [chart setupChartData];
        [self.charts addObject:chart];
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for chartRequest:%@\n %@", chartURLRequest, error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForStats {

    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:STATS_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.currentPrice = [NSString stringWithFormat: @"$%@", responseObject[@"market_price_usd"]];
        self.tradeVolume = [self formatTradeVolume:[responseObject[@"trade_volume_btc"] doubleValue]];
        self.hashRate = [self formatHashRate:[responseObject[@"hash_rate"] doubleValue]];
        self.blockTime = [self formatBlockTime:[responseObject[@"minutes_between_blocks"] doubleValue]];
        
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for stats: %@", error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForMarketCap {
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:MARKET_CAP_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.marketCap = [self formatMarketCap:responseObject];
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for market cap %@", error);
    }];
    return operation;
}

-(NSString*) formatMarketCap:(id)marketCapData {
    NSString *marketCapValue = [[NSString alloc] initWithData:marketCapData encoding:NSUTF8StringEncoding];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:marketCapValue];
    float marketCapInBillions = [decNumber floatValue] / 1000000000;
    return [NSString stringWithFormat:@"$%.2f B", marketCapInBillions];
}

-(NSString*) formatHashRate:(double)hashRate {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumFractionDigits:0];
    
    NSString *result = [fmt stringFromNumber:[NSNumber numberWithDouble:hashRate]];
    return [NSString stringWithFormat:@"%@ GH/s", result];
}

-(NSString*) formatBlockTime:(double)blockTime {
    return [NSString stringWithFormat:@"%.2f Min", blockTime];
}

-(NSString*) formatTradeVolume:(double)tradeVolume {
    return [NSString stringWithFormat:@"%.2f BTC", tradeVolume];

}

-(void) didFinishDownloadingOnePieceOfChartData {
    if ([self.charts count] == NUMBER_OF_CHARTS && [self.currentPrice length] &&
        [self.marketCap length] && [self.blockTime length] && [self.hashRate length] && [self.tradeVolume length]) {
        [self.delegate didFinishDownloadingChartData];
    }
}


@end
