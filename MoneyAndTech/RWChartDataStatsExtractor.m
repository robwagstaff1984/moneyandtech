//
//  RWChartDataStatsExtractor.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/13/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartDataStatsExtractor.h"
#define BLOCKCHAIN_MISSING_DECIMAL_PLACE 100000000

@implementation RWChartDataStatsExtractor


+(NSString*) extractLatestPrice:(id)tickerResponseObject {
    double marketPrice = [tickerResponseObject[@"USD"][@"15m"] doubleValue];
    return [NSString stringWithFormat:@"$%@", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:marketPrice]]];
}

+(NSString*) extractOpeningPrice:(id)statsResponseObject {
    double openingPrice = [statsResponseObject[@"market_price_usd"] doubleValue];
    return [NSString stringWithFormat:@"$%@", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:openingPrice]]];
}

+(NSString*) extractMarketCap:(id)statsResponseObject {
    float marketPrice = [statsResponseObject[@"market_price_usd"] floatValue];
    long long totalBC = [statsResponseObject[@"totalbc"] longLongValue] / BLOCKCHAIN_MISSING_DECIMAL_PLACE;
    
    float marketCapInBillions = (marketPrice * totalBC) / 1000000000;
    return [NSString stringWithFormat:@"$%.2f B", marketCapInBillions];
}

+(NSString*) extractTotalBitcoinsInCirculation:(id)statsResponseObject {
    long long totalBC = [statsResponseObject[@"totalbc"] longLongValue] / BLOCKCHAIN_MISSING_DECIMAL_PLACE;
    return [NSString stringWithFormat:@"%@ BTC", [[self zeroDigitsNumberFormater] stringFromNumber:[NSNumber numberWithLongLong:totalBC]]];
}


+(NSString*) extractTradeVolumeBTC:(id)statsResponseObject {
    double tradeVolume = [statsResponseObject[@"trade_volume_btc"] doubleValue];
    return [NSString stringWithFormat:@"%.2f BTC", tradeVolume];
}

+(NSString*) extractTradeVolumeUSD:(id)statsResponseObject {
    double tradeVolume = [statsResponseObject[@"trade_volume_usd"] doubleValue];
    return [NSString stringWithFormat:@"$%@", [[self zeroDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:tradeVolume]]];
}

+(NSString*) extractBlockTime:(id)statsResponseObject {
    double blockTime = [statsResponseObject[@"minutes_between_blocks"] doubleValue];
    return [NSString stringWithFormat:@"%.2f Min", blockTime];
}

+(NSString*) extractNumberOfTransaction:(id)statsResponseObject {
    int numberOfTransactions = [statsResponseObject[@"n_tx"] integerValue];
    return [NSString stringWithFormat:@"%d", numberOfTransactions];
}

+(NSString*) extractHashRate:(id)statsResponseObject {
    double hashRate = [statsResponseObject[@"hash_rate"] doubleValue];
    return [NSString stringWithFormat:@"%@ GH/s", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:hashRate]]];
}

+(NSString*) extractDifficulty:(id)statsResponseObject {
    double difficulty = [statsResponseObject[@"difficulty"] doubleValue];
    return [NSString stringWithFormat:@"%@", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:difficulty]]];
}

+(NSString*) extractTransactionFreesPerDay:(id)statsResponseObject {
    long long transactionFeesPerDay = [statsResponseObject[@"total_fees_btc"] longLongValue] / BLOCKCHAIN_MISSING_DECIMAL_PLACE;
    return [NSString stringWithFormat:@"%@ BTC", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithLongLong:transactionFeesPerDay]]];
}

+(NSString*) extractElectricityConsumputionPerDay:(id)statsResponseObject {
    double electricityConsumption = [statsResponseObject[@"electricity_consumption"] doubleValue] / 1000000;
    return  [NSString stringWithFormat:@"%@ MWh", [[self twoDigitsNumberFormater] stringFromNumber:[NSNumber numberWithDouble:electricityConsumption]]];
}

+(NSNumberFormatter*) zeroDigitsNumberFormater {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    return numberFormatter;
}

+(NSNumberFormatter*) twoDigitsNumberFormater {
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    return numberFormatter;
}

@end
