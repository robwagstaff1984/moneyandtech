//
//  RWChart.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChart.h"
#import "RWChartDataItem.h"

@interface RWChart()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation RWChart

- (RWChart*)initWithTitle:(NSString*)title URL:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.title = title;
        self.url = url;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMMM d yyyy"];
        self.chartDataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setupChartData {
    [self formatChartData];
    self.lineChartData = [LCLineChartData new];
    self.lineChartData.xMin = [self minDate];
    self.lineChartData.xMax = [self maxDate];
    self.lineChartData.title = self.title;
    self.lineChartData.color = [UIColor colorWithRed:0 green:0 blue:182/255.0 alpha:1.0];
    self.lineChartData.itemCount = [self.chartDataItems count];
    
    __weak typeof(self) weakSelf = self;
    self.lineChartData.getData = ^(NSUInteger item) {
        RWChartDataItem* currentChartDataItem = weakSelf.chartDataItems[item];
        return [LCLineChartDataItem dataItemWithX:currentChartDataItem.x y:currentChartDataItem.y xLabel:currentChartDataItem.xLabel dataLabel:currentChartDataItem.yLabel];
    };
}

-(void) formatChartData {
    
    for(NSUInteger i = 0; i < [self.chartRawValues count]; ++i) {
        RWChartDataItem* chartDataItem = [[RWChartDataItem alloc] init];
        chartDataItem.x = [self.chartRawValues[i][@"x"] intValue];
        chartDataItem.y = [self.chartRawValues[i][@"y"] floatValue];
        chartDataItem.xLabel = [self formattedDate:[NSDate dateWithTimeIntervalSince1970:chartDataItem.x]];
        chartDataItem.yLabel = [NSString stringWithFormat:@"$%.2f", chartDataItem.y];
        [self.chartDataItems addObject:chartDataItem];
    }
}

-(NSNumber*) maxPrice {
    NSPredicate *maxPricePredicate = [NSPredicate predicateWithFormat:@"SELF.y == %@.@max.y", self.chartRawValues];
    return [self.chartRawValues filteredArrayUsingPredicate:maxPricePredicate][0][@"y"];
}
-(int) minDate {
    NSPredicate *minDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@min.x", self.chartRawValues];
    return [[self.chartRawValues filteredArrayUsingPredicate:minDatePredicate][0][@"x"] intValue];
}
-(int) maxDate {
    NSPredicate *maxDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@max.x", self.chartRawValues];
    return [[self.chartRawValues filteredArrayUsingPredicate:maxDatePredicate][0][@"x"] intValue];
}

-(NSString*) formattedDate:(NSDate*)date {
    return [self.dateFormatter stringFromDate:date];
}

-(NSArray*) ySteps {
    
    int roundedMaxPrice = 100*(([self.maxPrice intValue]+50)/100);
    float roundedQuarterPrice = roundedMaxPrice * 0.25;
    float roundedHalfPrice = roundedMaxPrice * 0.5;
    float roundedThreeQuarterPrice = roundedMaxPrice * 0.75;
    float roundedFiveQuarterPrice = roundedMaxPrice * 1.25;
    
    return @[[NSString stringWithFormat:@"%@0",self.labelPrefix], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedQuarterPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedHalfPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedThreeQuarterPrice], [NSString stringWithFormat:@"%@%d", self.labelPrefix, roundedMaxPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedFiveQuarterPrice]];
}

-(float) yMax {
    int roundedMaxPrice = 100*(([self.maxPrice intValue]+50)/100);
    float roundedFiveQuarterPrice = roundedMaxPrice * 1.25;
    return roundedFiveQuarterPrice;
}


@end
