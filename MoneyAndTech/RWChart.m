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
@property (nonatomic, strong) NSDateFormatter *shortDateFormatter;
@property (nonatomic, strong) NSNumberFormatter *labelNumberFormatter;
@property (nonatomic, strong) NSNumberFormatter *axisNumberFormatter;
@property (nonatomic) DataPeriod cachedDataPeriod;
@property (nonatomic, strong) NSNumber* cachedMinPrice;
@property (nonatomic, strong) NSNumber* cachedMaxPrice;

@property (nonatomic, strong) NSMutableArray* chartRawYValues;

@end

@implementation RWChart

- (RWChart*)initWithTitle:(NSString*)title chartNumber:(int)chartNumber URL:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.title = title;
        self.chartNumber = chartNumber;
        self.url = url;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMM d yyyy"];
        self.shortDateFormatter = [[NSDateFormatter alloc] init];
        [self.shortDateFormatter setDateFormat:@"MMM d"];
        self.labelNumberFormatter = [[NSNumberFormatter alloc] init];
        [self.labelNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.labelNumberFormatter setMaximumFractionDigits:0];
        self.axisNumberFormatter = [[NSNumberFormatter alloc] init];
        [self.axisNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [self.axisNumberFormatter setMaximumFractionDigits:0];
        self.chartDataItems = [[NSMutableArray alloc] init];
        self.chartRawYValues = [[NSMutableArray alloc] init];
        
        self.labelPrefix = @"";
        self.labelSuffix = @"";
    }
    return self;
}

-(void) setupChartData {
    [self formatChartData];
    self.lineChartData = [LCLineChartData new];
    self.dataPeriod = DataPeriodSixMonth;
    self.lineChartData.color = [UIColor colorWithRed:0 green:0 blue:182/255.0 alpha:1.0];

    __weak typeof(self) weakSelf = self;
    self.lineChartData.getData = ^(NSUInteger item) {
        NSInteger dataPeriodLength = MIN([weakSelf.chartDataItems count], weakSelf.dataPeriod);
        NSInteger itemNumber = [weakSelf.chartDataItems count] - dataPeriodLength + item;
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
        
        [self.chartRawYValues addObject:self.chartRawValues[i][@"y"]];
        if(self.shouldScaleValues) {
            chartDataItem.y = (chartDataItem.y / 1000.0);
        }
        
        chartDataItem.xLabel = [self formattedDate:chartDataItem.x];

        chartDataItem.yLabel = [self displayLabelForValue:chartDataItem.y];
        [self.chartDataItems addObject:chartDataItem];
    }
}

-(NSNumber*) maxPrice {
    if(self.cachedDataPeriod != self.dataPeriod) {
        self.cachedDataPeriod = self.dataPeriod;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.cachedMaxPrice = [[self currentDataPeriodRawYValue] valueForKeyPath:@"@max.doubleValue"];
            if(self.shouldScaleValues) {
                self.cachedMaxPrice = [NSNumber numberWithDouble:[self.cachedMaxPrice doubleValue] / 1000.0];
            }
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    return self.cachedMaxPrice;
}

-(NSNumber*) minPrice {
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block NSNumber* minPrice;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        minPrice= [[self currentDataPeriodRawYValue] valueForKeyPath:@"@min.doubleValue"];
        if(self.shouldScaleValues) {
            minPrice = [NSNumber numberWithDouble:[minPrice doubleValue] / 1000.0];
        }
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return minPrice;
}

-(int) minDate {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block int minDate;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        minDate = [[self currentDataPeriodRawValue][0][@"x"] intValue];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return minDate;
}
-(int) maxDate {
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __block int maxDate;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray* currentDataPeriodRawValue = [self currentDataPeriodRawValue];
        maxDate = [currentDataPeriodRawValue[[currentDataPeriodRawValue count] - 1][@"x"] intValue];
        dispatch_semaphore_signal(sema);
    });
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return maxDate;
}

-(NSArray*) currentDataPeriodRawValue {
    NSInteger dataPeriodLength = MIN([self.chartRawValues  count], self.dataPeriod);
    return [self.chartRawValues subarrayWithRange:NSMakeRange([self.chartRawValues count] - dataPeriodLength, dataPeriodLength)];
}

-(NSArray*) currentDataPeriodRawYValue {
    NSInteger dataPeriodLength = MIN([self.chartRawValues  count], self.dataPeriod);
    return [self.chartRawYValues subarrayWithRange:NSMakeRange([self.chartRawYValues count] - dataPeriodLength, dataPeriodLength)];
}

-(NSString*) formattedDate:(int)date {
    return [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
}

-(NSString*) formattedShortDate:(int)date {
    if(self.dataPeriod != DataPeriodAllTime) {
        return [self.shortDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    }
    return [self formattedDate:date];
}

-(NSArray*) xSteps {
    
    int minDate = [self minDate];
    int maxDate = [self maxDate];
    float quarterDate = minDate + ((maxDate - minDate)*0.25);
    float halfDate = minDate + ((maxDate - minDate)*0.5);
    float threeQuarterDate = minDate + ((maxDate - minDate)*0.75);

    NSArray* xSteps = @[[self formattedShortDate:minDate],  [self formattedShortDate:quarterDate], [self formattedShortDate:halfDate],  [self formattedShortDate:threeQuarterDate], [self formattedShortDate:maxDate]];
    
    return xSteps;
}

-(NSArray*) ySteps {//TODO needs work. dynamic round value and sometimes data is below 0;
    
    int roundToValue = [self roundToValue];
    
    int roundedMinPrice = roundToValue * floorf(([self.minPrice intValue]/roundToValue)+0.5);
    int roundedMaxPrice = roundToValue * ceilf(([self.maxPrice intValue]/roundToValue)+0.5);
    int spreadOfValues = roundedMaxPrice - roundedMinPrice;
    
    float roundedQuarterPrice = roundedMinPrice + (spreadOfValues * 0.25);
    float roundedHalfPrice = roundedMinPrice + (spreadOfValues * 0.5);
    float roundedThreeQuarterPrice = roundedMinPrice + (spreadOfValues * 0.75);
    
    self.yMin = (float)roundedMinPrice;
    self.yMax = roundedMaxPrice;
    
    return @[[self displayAxisForValue:(float)roundedMinPrice], [self displayAxisForValue:roundedQuarterPrice], [self displayAxisForValue:roundedHalfPrice], [self displayAxisForValue:roundedThreeQuarterPrice], [self displayAxisForValue:roundedMaxPrice]];
}

-(int) roundToValue {
    if([self.maxPrice intValue] < 1000) {
        return 10;
    } else if ([self.maxPrice intValue] < 10000) {
        return 100;
    } else if ([self.maxPrice intValue] < 100000) {
        return 1000;
    } else if ([self.maxPrice intValue] < 1000000) {
        return 10000;
    } else {
        return 100000;
    }
}

#pragma mark - helpers
-(NSString*) displayLabelForValue:(float)value {
    if(([self.labelPrefix isEqualToString:@"$"] && value < 1000000) || [self.labelSuffix isEqualToString:@" GB"]) {
        [self.labelNumberFormatter setMinimumFractionDigits:2];
        [self.labelNumberFormatter setMaximumFractionDigits:2];
    }
    return [NSString stringWithFormat:@"%@%@%@", self.labelPrefix, [self.labelNumberFormatter stringFromNumber:@(value)], self.labelSuffix];
}

-(NSString*) displayAxisForValue:(float)value {
    return [NSString stringWithFormat:@"%@%@%@", self.labelPrefix, [self.axisNumberFormatter stringFromNumber:@(value)], self.labelSuffix];
}

#pragma mark - override setters
-(void) setDataPeriod:(DataPeriod)dataPeriod {
    _dataPeriod = dataPeriod;
    [self updateLineChartData];
}

-(void) setLabelPrefix:(NSString *)labelPrefix {
    _labelPrefix = labelPrefix;

}

-(void) setLabelSuffix:(NSString *)labelSuffix {
    _labelSuffix = labelSuffix;
}

@end
