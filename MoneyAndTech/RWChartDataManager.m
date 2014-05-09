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

#define CURRENT_PRICE_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/ticker"]]
#define MARKET_CAP_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/q/marketcap"]]
#define HASH_RATE_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/q/hashrate"]]
#define BLOCK_TIME_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/q/interval"]]

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

    AFHTTPRequestOperation* currentPriceOperation = [self dataRequestOperationForCurrentPrice];
    AFHTTPRequestOperation* marketCapOperation = [self dataRequestOperationForMarketCap];
    AFHTTPRequestOperation* hashRateOperation = [self dataRequestOperationForHashRate];
    AFHTTPRequestOperation* blockTimeOperation = [self dataRequestOperationForBlockTime];
    AFHTTPRequestOperation* marketPriceUSDOperation = [self dataRequestOperationForChart:marketPriceUSDChart];
    AFHTTPRequestOperation* numberOfTransactionsPerDayOperation = [self dataRequestOperationForChart:numberOfTransactionsPerDayChart];

    [marketCapOperation addDependency:currentPriceOperation];
    [hashRateOperation addDependency:marketCapOperation];
    [blockTimeOperation addDependency:hashRateOperation];
    [marketPriceUSDOperation addDependency:blockTimeOperation];
    [numberOfTransactionsPerDayOperation addDependency:marketPriceUSDOperation];
    [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager].operationQueue addOperations:@[currentPriceOperation, marketCapOperation,  hashRateOperation, blockTimeOperation, marketPriceUSDOperation,numberOfTransactionsPerDayOperation ] waitUntilFinished:NO];
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

-(AFHTTPRequestOperation*) dataRequestOperationForCurrentPrice {
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:CURRENT_PRICE_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.currentPrice = [NSString stringWithFormat: @"$%@", responseObject[@"USD"][@"15m"]];
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for current price %@", error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForMarketCap {
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:MARKET_CAP_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *marketCapValue = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:marketCapValue];
        float marketCapInBillions = [decNumber floatValue] / 1000000000;
        self.marketCap = [NSString stringWithFormat:@"$%.2f B", marketCapInBillions];
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for market cap %@", error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForHashRate {

    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:HASH_RATE_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.hashRate = [self formatHashRate:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for hash rate cap %@", error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForBlockTime {
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:BLOCK_TIME_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.blockTime = [self formatBlockTime:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for block time %@", error);
    }];
    return operation;
}

-(NSString*) formatHashRate:(id)hashRateData {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    [fmt setMaximumFractionDigits:0];
    
    NSString *hashRate = [[NSString alloc] initWithData:hashRateData encoding:NSUTF8StringEncoding];
    NSString *result = [fmt stringFromNumber:[NSDecimalNumber decimalNumberWithString:hashRate]];
    return [NSString stringWithFormat:@"%@ GH/s", result];
}

-(NSString*) formatBlockTime:(id)blockTimeData {
    NSString *blockTime = [[NSString alloc] initWithData:blockTimeData encoding:NSUTF8StringEncoding];
    NSDecimalNumber* blockTimeNumber =  [NSDecimalNumber decimalNumberWithString:blockTime];
    return [NSString stringWithFormat:@"%.2f Min", [blockTimeNumber floatValue] / 60.0];
}
-(void) didFinishDownloadingOnePieceOfChartData {
    if ([self.charts count] == NUMBER_OF_CHARTS && [self.currentPrice length] && [self.marketCap length] && [self.blockTime length]) {
        [self.delegate didFinishDownloadingChartData];
    }
}


@end
