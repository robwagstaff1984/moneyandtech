//
//  RWChartViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWChartsViewController.h"
#import "LCLineChartView.h"
#import "RWChartDataItem.h"

@interface RWChartsViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSArray* chartValues;
@property (nonatomic, strong) LCLineChartData* marketPriceUSDData;
@property (nonatomic, strong) NSMutableArray* chartDataItems;

@end

@implementation RWChartsViewController


- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Charts";
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"MMMM d yyyy"];
        self.chartDataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveData];
    [self setupChartData];
    [self setupChart];

}
#pragma mark retrieve data
-(void) retrieveData {
        //TODO replace with network call
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"chart-data" ofType:@"json"];
    NSDictionary *transaction = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:nil];
    self.chartValues = (NSArray*)transaction[@"values"];
}

#pragma mark - chart data

-(void) setupChartData {
    [self formatChartData];
    self.marketPriceUSDData = [LCLineChartData new];
    self.marketPriceUSDData.xMin = [self minDate];
    self.marketPriceUSDData.xMax = [self maxDate];
    self.marketPriceUSDData.title = @"Market Price (USD)";
    self.marketPriceUSDData.color = [UIColor blueColor];
    self.marketPriceUSDData.itemCount = [self.chartValues count];
    
    __weak typeof(self) weakSelf = self;
    self.marketPriceUSDData.getData = ^(NSUInteger item) {
        RWChartDataItem* currentChartDataItem = weakSelf.chartDataItems[item];
        return [LCLineChartDataItem dataItemWithX:currentChartDataItem.x y:currentChartDataItem.y xLabel:currentChartDataItem.xLabel dataLabel:currentChartDataItem.yLabel];
    };
}

-(void) formatChartData {

    for(NSUInteger i = 0; i < [self.chartValues count]; ++i) {
        RWChartDataItem* chartDataItem = [[RWChartDataItem alloc] init];
        chartDataItem.x = [self.chartValues[i][@"x"] intValue];
        chartDataItem.y = [self.chartValues[i][@"y"] floatValue];
        chartDataItem.xLabel = [self formattedDate:[NSDate dateWithTimeIntervalSince1970:chartDataItem.x]];
        chartDataItem.yLabel = [NSString stringWithFormat:@"$%.2f", chartDataItem.y];
        [self.chartDataItems addObject:chartDataItem];
    }
}

#pragma mark - chart view
-(void) setupChart {

    int roundedMaxPrice = 100*(([[self maxPrice] intValue]+50)/100);
    float roundedQuarterPrice = roundedMaxPrice * 0.25;
    float roundedHalfPrice = roundedMaxPrice * 0.5;
    float roundedThreeQuarterPrice = roundedMaxPrice * 0.75;
    float roundedFiveQuarterPrice = roundedMaxPrice * 1.25;
    
    LCLineChartView *chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    chartView.yMin = 0;
    chartView.yMax = roundedFiveQuarterPrice;
    chartView.ySteps = @[@"$0",[NSString stringWithFormat:@"$%.0f", roundedQuarterPrice], [NSString stringWithFormat:@"$%.0f", roundedHalfPrice], [NSString stringWithFormat:@"$%.0f", roundedThreeQuarterPrice], [NSString stringWithFormat:@"$%d", roundedMaxPrice], [NSString stringWithFormat:@"$%.0f", roundedFiveQuarterPrice]];
    chartView.data = @[self.marketPriceUSDData];
    chartView.drawsDataPoints = NO;
    
    [self.view addSubview:chartView];
}

#pragma mark - predicate helpers
-(NSNumber*) maxPrice {
    NSPredicate *maxPricePredicate = [NSPredicate predicateWithFormat:@"SELF.y == %@.@max.y", self.chartValues];
    return [self.chartValues filteredArrayUsingPredicate:maxPricePredicate][0][@"y"];
}
-(int) minDate {
    NSPredicate *minDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@min.x", self.chartValues];
    return [[self.chartValues filteredArrayUsingPredicate:minDatePredicate][0][@"x"] intValue];
}
-(int) maxDate {
    NSPredicate *maxDatePredicate = [NSPredicate predicateWithFormat:@"SELF.x == %@.@max.x", self.chartValues];
    return [[self.chartValues filteredArrayUsingPredicate:maxDatePredicate][0][@"x"] intValue];
}

-(NSString*) formattedDate:(NSDate*)date {
    return [self.dateFormatter stringFromDate:date];
}






@end
