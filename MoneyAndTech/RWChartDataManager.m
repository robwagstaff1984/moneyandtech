//
//  RWChartDataManager.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/9/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartDataManager.h"
#import "RWChart.h"


#define MARKET_PRICE_USD_TITLE @"Market Price\n(USD)"
#define MARKET_PRICE_USD_URL [NSURL URLWithString:@"https://blockchain.info/charts/market-price?timespan=all&format=json"]

#define NUMBER_OF_TRANSACTIONS_PER_DAY_URL [NSURL URLWithString:@"https://blockchain.info/charts/n-transactions?timespan=all&format=json"]
#define NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE @"Transactions\nPer Day"

#define USD_EXCHANGE_TRADE_VOLUME_URL [NSURL URLWithString:@"https://blockchain.info/charts/trade-volume?timespan=all&format=json"]
#define USD_EXCHANGE_TRADE_VOLUME_TITLE @"USD Exchange\nTrade Volume"

#define STATS_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/stats?format=json"]]
#define MARKET_CAP_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/q/marketcap"]]


#define NUMBER_OF_CHARTS 3

@implementation RWChartDataManager

+(RWChartDataManager*) sharedChartDataManager {
    
    static RWChartDataManager* _sharedChartDataManager;
    if(!_sharedChartDataManager) {
        _sharedChartDataManager = [self new];
        _sharedChartDataManager.charts = [NSMutableArray arrayWithCapacity: NUMBER_OF_CHARTS];
    }
    return _sharedChartDataManager;
}

-(void) retrieveData {
    
    NSLog(@"start load chart");
    RWChart* marketPriceUSDChart = [[RWChart alloc] initWithTitle:MARKET_PRICE_USD_TITLE chartNumber:0 URL:MARKET_PRICE_USD_URL];
    marketPriceUSDChart.labelPrefix = @"$";
    RWChart* numberOfTransactionsPerDayChart = [[RWChart alloc] initWithTitle:NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE chartNumber:1 URL:NUMBER_OF_TRANSACTIONS_PER_DAY_URL];
    RWChart* usdExchangeVolumeChart = [[RWChart alloc] initWithTitle:USD_EXCHANGE_TRADE_VOLUME_TITLE chartNumber:2 URL:USD_EXCHANGE_TRADE_VOLUME_URL];
    usdExchangeVolumeChart.labelPrefix = @"$";

    NSArray* dataRequestOperations = @[[self dataRequestOperationForStats], [self dataRequestOperationForMarketCap], [self dataRequestOperationForChart:marketPriceUSDChart], [self dataRequestOperationForChart:numberOfTransactionsPerDayChart], [self dataRequestOperationForChart:usdExchangeVolumeChart]];

    [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager].operationQueue addOperations:dataRequestOperations waitUntilFinished:NO];
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
    NSLog(@"got one piece of stats data");
    if ([self isAllBitcoinStatisticsDataDownloaded]) {
        [self.charts sortUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"chartNumber" ascending:YES]]];
        [self broadcastBitcoinStatisticsDownloaded];
    }
}

-(BOOL) isAllBitcoinStatisticsDataDownloaded {
    return [self.charts count] == NUMBER_OF_CHARTS && [self.currentPrice length] && [self.marketCap length] && [self.blockTime length] && [self.hashRate length] && [self.tradeVolume length];
}

-(void) broadcastBitcoinStatisticsDownloaded {
    NSLog(@"got all data");
    [[NSNotificationCenter defaultCenter] postNotificationName:BITCOIN_STATISTICS_DOWNLOADED object:self userInfo:nil];
}

@end
