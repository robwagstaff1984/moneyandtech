//
//  RWChart.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//


#import "LCLineChartView.h"
#import "RWAFHTTPRequestOperationManager.h"

typedef enum {
    DataPeriodWeek = 7,
    DataPeriodMonth = 30,
    DataPeriodSixMonth = 180,
    DataPeriodYear = 365,
    DataPeriodAllTime = 99999
} DataPeriod;

@interface RWChart : NSObject

- (RWChart*)initWithTitle:(NSString*)title chartNumber:(int)chartNumber URL:(NSURL*)url;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, assign) int chartNumber;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) LCLineChartData* lineChartData;
@property (nonatomic, strong) NSArray* chartRawValues;
@property (nonatomic, strong) NSMutableArray* chartDataItems;
@property (nonatomic, copy) void (^successBlock)(RWChart*);
@property (nonatomic, strong) NSString* labelPrefix;
@property (nonatomic) DataPeriod dataPeriod;

@property (nonatomic, assign) float yMin;
@property (nonatomic, assign) float yMax;

-(void) setupChartData;
-(NSNumber*) maxPrice;
-(NSArray*) ySteps;


@end

