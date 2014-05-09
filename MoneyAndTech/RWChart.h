//
//  RWChart.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//


#import "LCLineChartView.h"
#import "RWAFHTTPRequestOperationManager.h"

@interface RWChart : NSObject

- (RWChart*)initWithTitle:(NSString*)title URL:(NSURL*)url;

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSURL* url;
@property (nonatomic, strong) LCLineChartData* lineChartData;
@property (nonatomic, strong) NSArray* chartRawValues;
@property (nonatomic, strong) NSMutableArray* chartDataItems;
@property (nonatomic, copy) void (^successBlock)(RWChart*);
@property (nonatomic, strong) NSString* labelPrefix;

-(void) setupChartData;
-(NSNumber*) maxPrice;
-(NSArray*) ySteps;
-(float) yMax;

@end

