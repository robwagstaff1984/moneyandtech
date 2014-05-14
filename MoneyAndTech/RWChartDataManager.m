//
//  RWChartDataManager.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/9/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartDataManager.h"
#import "RWChart.h"
#import "RWChartDataStatsExtractor.h"


#define MARKET_PRICE_USD_TITLE @"Market Price\n(USD)"
#define MARKET_PRICE_USD_URL [NSURL URLWithString:@"https://blockchain.info/charts/market-price?timespan=all&format=json"]

#define NUMBER_OF_TRANSACTIONS_PER_DAY_URL [NSURL URLWithString:@"https://blockchain.info/charts/n-transactions?timespan=all&format=json"]
#define NUMBER_OF_TRANSACTIONS_PER_DAY_TITLE @"Transactions\nPer Day"

#define USD_EXCHANGE_TRADE_VOLUME_URL [NSURL URLWithString:@"https://blockchain.info/charts/trade-volume?timespan=all&format=json"]
#define USD_EXCHANGE_TRADE_VOLUME_TITLE @"USD Exchange\nTrade Volume"

#define CURRENT_PRICE_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/ticker?format=json"]]
#define STATS_URL_REQUEST [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://blockchain.info/stats?format=json"]]





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

    NSArray* dataRequestOperations = @[[self dataRequestOperationForLatestPrice], [self dataRequestOperationForStats], [self dataRequestOperationForChart:marketPriceUSDChart], [self dataRequestOperationForChart:numberOfTransactionsPerDayChart], [self dataRequestOperationForChart:usdExchangeVolumeChart]];

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

-(AFHTTPRequestOperation*) dataRequestOperationForLatestPrice {
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:CURRENT_PRICE_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.latestPrice = [RWChartDataStatsExtractor extractLatestPrice:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for latest Price: %@", error);
    }];
    return operation;
}

-(AFHTTPRequestOperation*) dataRequestOperationForStats {

    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedJSONRequestOperationManager] HTTPRequestOperationWithRequest:STATS_URL_REQUEST success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.openingPrice = [RWChartDataStatsExtractor extractOpeningPrice:responseObject];
        self.marketCap = [RWChartDataStatsExtractor extractMarketCap:responseObject];
        self.totalBitcoinsInCirculation = [RWChartDataStatsExtractor extractTotalBitcoinsInCirculation:responseObject];
        self.tradeVolumeBTC = [RWChartDataStatsExtractor extractTradeVolumeBTC:responseObject];
        self.tradeVolumeUSD = [RWChartDataStatsExtractor extractTradeVolumeUSD:responseObject];
        
        self.blockTime = [RWChartDataStatsExtractor extractBlockTime:responseObject];
        self.numberOfTransactions = [RWChartDataStatsExtractor extractNumberOfTransaction:responseObject];
        self.hashRate = [RWChartDataStatsExtractor extractHashRate:responseObject];
        self.difficulty = [RWChartDataStatsExtractor extractDifficulty:responseObject];
        self.transactionFeesPerDay = [RWChartDataStatsExtractor extractTransactionFreesPerDay:responseObject];
        self.electricityConsumputionPerDay = [RWChartDataStatsExtractor extractElectricityConsumputionPerDay:responseObject];
        
        [self didFinishDownloadingOnePieceOfChartData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure for stats: %@", error);
    }];
    return operation;
}

-(void) didFinishDownloadingOnePieceOfChartData {
    NSLog(@"got one piece of stats data");
    if ([self isAllBitcoinStatisticsDataDownloaded]) {
        [self.charts sortUsingDescriptors: @[[NSSortDescriptor sortDescriptorWithKey:@"chartNumber" ascending:YES]]];
        [self broadcastBitcoinStatisticsDownloaded];
    }
}

-(BOOL) isAllBitcoinStatisticsDataDownloaded {
    return [self.charts count] == NUMBER_OF_CHARTS && [self.latestPrice length] && [self.openingPrice length];
}

-(void) broadcastBitcoinStatisticsDownloaded {
    NSLog(@"got all data");
    [[NSNotificationCenter defaultCenter] postNotificationName:BITCOIN_STATISTICS_DOWNLOADED object:self userInfo:nil];
}

-(NSString*) calculatePercentChange:(id)responseObject {
    return @"TEMP %";
}


@end
