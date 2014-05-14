//
//  RWChartDataStatsExtractor.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/13/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWChartDataStatsExtractor : NSObject

+(NSString*) extractLatestPrice:(id)tickerResponseObject;
+(NSString*) extractOpeningPrice:(id)statsResponseObject;
+(NSString*) extractMarketCap:(id)statsResponseObject;
+(NSString*) extractTotalBitcoinsInCirculation:(id)statsResponseObject;
+(NSString*) extractTradeVolumeBTC:(id)statsResponseObject;
+(NSString*) extractTradeVolumeUSD:(id)statsResponseObject;

+(NSString*) extractNumberOfTransaction:(id)statsResponseObject;
+(NSString*) extractBlockTime:(id)statsResponseObject;
+(NSString*) extractHashRate:(id)statsResponseObject;
+(NSString*) extractDifficulty:(id)statsResponseObject;
+(NSString*) extractTransactionFreesPerDay:(id)statsResponseObject;
+(NSString*) extractElectricityConsumputionPerDay:(id)statsResponseObject;

@end
