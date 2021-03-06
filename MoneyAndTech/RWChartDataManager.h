//
//  RWChartDataManager.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/9/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWChartDataManager : NSObject

//PRICE
@property (nonatomic, strong) NSString* openingPrice;
@property (nonatomic, strong) NSString* latestPrice;

//MARKET
@property (nonatomic, strong) NSString* marketCap;
@property (nonatomic, strong) NSString* totalBitcoinsInCirculation;
@property (nonatomic, strong) NSString* tradeVolumeBTC;
@property (nonatomic, strong) NSString* tradeVolumeUSD;

//NETWORK
@property (nonatomic, strong) NSString* blockTime;
@property (nonatomic, strong) NSString* numberOfTransactions;
@property (nonatomic, strong) NSString* hashRate;
@property (nonatomic, strong) NSString* difficulty;
@property (nonatomic, strong) NSString* transactionFeesPerDay;
@property (nonatomic, strong) NSString* totalBTCSent;


@property (nonatomic, strong) NSMutableArray* charts;
@property (nonatomic) int numberOfChartDataLoadErrors;

+(RWChartDataManager*) sharedChartDataManager;
-(void) retrieveData;
-(void) retrieveLatestPrice;
-(double) percentChange;
-(int) numberOfCharts;
@end
