//
//  RWChartDataManager.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/9/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RWChartDataManagerDelegate <NSObject>

@required
-(void) didFinishDownloadingChartData;
@end

@interface RWChartDataManager : NSObject

@property (nonatomic, strong) NSString* currentPrice;
@property (nonatomic, strong) NSString* marketCap;
@property (nonatomic, strong) NSString* tradeVolume;
@property (nonatomic, strong) NSString* hashRate;
@property (nonatomic, strong) NSString* blockTime;

@property (nonatomic, strong) NSMutableArray* charts;
@property (nonatomic, assign) id<RWChartDataManagerDelegate> delegate;

+(RWChartDataManager*) sharedChartDataManager;
-(void) retrieveData;
@end
