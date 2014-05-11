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
        [self.dateFormatter setDateFormat:@"MMM d yyyy"];
        self.chartDataItems = [[NSMutableArray alloc] init];
        self.labelPrefix = @"";
    }
    return self;
}

-(void) setupChartData {
    [self formatChartData];
    self.lineChartData = [LCLineChartData new];
    self.dataPeriod = DataPeriodMonth;
    self.lineChartData.color = [UIColor colorWithRed:0 green:0 blue:182/255.0 alpha:1.0];

    __weak typeof(self) weakSelf = self;
    self.lineChartData.getData = ^(NSUInteger item) {
        int dataPeriodLength = MIN([weakSelf.chartDataItems count], weakSelf.dataPeriod);
        int itemNumber = [weakSelf.chartDataItems count] - dataPeriodLength + item;
        RWChartDataItem* currentChartDataItem = weakSelf.chartDataItems[itemNumber];
        return [LCLineChartDataItem dataItemWithX:currentChartDataItem.x y:currentChartDataItem.y xLabel:currentChartDataItem.xLabel dataLabel:currentChartDataItem.yLabel];
    };
}

-(void) updateLineChartData {
    self.lineChartData.itemCount = MIN([self.chartDataItems count], self.dataPeriod);
    self.lineChartData.xMin = [self minDate];
    self.lineChartData.xMax = [self maxDate];
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
    NSPredicate *maxPricePredicate = [NSPredicate predicateWithFormat:@"SELF.y == %@.@max.y", [self currentDataPeriodRawValue]];
    return [[self currentDataPeriodRawValue] filteredArrayUsingPredicate:maxPricePredicate][0][@"y"];
}

-(NSNumber*) minPrice {
    NSPredicate *maxPricePredicate = [NSPredicate predicateWithFormat:@"SELF.y == %@.@min.y", [self currentDataPeriodRawValue]];
    return [[self currentDataPeriodRawValue] filteredArrayUsingPredicate:maxPricePredicate][0][@"y"];
}

-(int) minDate {
    NSPredicate *minDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@min.x", [self currentDataPeriodRawValue]];
    return [[[self currentDataPeriodRawValue] filteredArrayUsingPredicate:minDatePredicate][0][@"x"] intValue];
}
-(int) maxDate {
    NSPredicate *maxDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@max.x", [self currentDataPeriodRawValue]];
    return [[[self currentDataPeriodRawValue] filteredArrayUsingPredicate:maxDatePredicate][0][@"x"] intValue];
}

-(NSArray*) currentDataPeriodRawValue {
    int dataPeriodLength = MIN([self.chartRawValues  count], self.dataPeriod);
    return [self.chartRawValues subarrayWithRange:NSMakeRange([self.chartRawValues count] - dataPeriodLength, dataPeriodLength)];
}

-(NSString*) formattedDate:(NSDate*)date {
    return [self.dateFormatter stringFromDate:date];
}

-(NSArray*) ySteps {
    
    int roundToValue = 10;
    
    int roundedMinPrice = roundToValue*(([self.minPrice intValue]+(roundToValue/2))/roundToValue);
    int roundedMaxPrice = roundToValue*(([self.maxPrice intValue]+(roundToValue/2))/roundToValue);
    int spreadOfValues = roundedMaxPrice - roundedMinPrice;
    
    float roundedQuarterPrice = roundedMinPrice + (spreadOfValues * 0.25);
    float roundedHalfPrice = roundedMinPrice + (spreadOfValues * 0.5);
    float roundedThreeQuarterPrice = roundedMinPrice + (spreadOfValues * 0.75);
    float roundedFiveQuarterPrice = roundedMinPrice + (spreadOfValues * 1.25);
    
    self.yMin = (float)roundedMinPrice;
    self.yMax = roundedFiveQuarterPrice;
    
    return @[[NSString stringWithFormat:@"%@%.0f", self.labelPrefix, (float)roundedMinPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedQuarterPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedHalfPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedThreeQuarterPrice], [NSString stringWithFormat:@"%@%d", self.labelPrefix, roundedMaxPrice], [NSString stringWithFormat:@"%@%.0f", self.labelPrefix, roundedFiveQuarterPrice]];
}

-(void) setDataPeriod:(DataPeriod)dataPeriod {
    _dataPeriod = dataPeriod;
    [self updateLineChartData];
}



@end
