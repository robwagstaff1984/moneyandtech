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
#import <AFNetworking/AFNetworking.h>
#import "RWAFHTTPRequestOperationManager.h"
#import "RWChart.h"
#import "RWChartDataManager.h"
#define TITLE_PICKER_WIDTH 270


@interface RWChartsViewController ()

@property (nonatomic, strong) LCLineChartView* chartView;
@property (nonatomic, strong) RWChart* currentChart;
@property (nonatomic, strong) UISegmentedControl *datePeriodSegmentedControl;
@property (nonatomic, strong) V8HorizontalPickerView* pickerView;

@end

@implementation RWChartsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Charts";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startSpinner];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishDownloadingChartData)
                                                 name:BITCOIN_STATISTICS_DOWNLOADED
                                               object:nil];
    [[RWChartDataManager sharedChartDataManager] retrieveData];
    
}

#pragma mark retrieve data

-(void) didFinishDownloadingChartData {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[0];
    [self addAlternateChartsPickerView];
    [self setupChartView];

    [self addAlternateDataPeriodButtons];

    [self stopSpinner];
}

#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, self.pickerView.frame.origin.y + self.pickerView.frame.size.height + 10, SCREEN_WIDTH, SCREEN_WIDTH * 0.8)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];

    [self updateChartView];

    [self.view addSubview:self.chartView];
}

-(void) updateChartView {

    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.yMin = self.currentChart.yMin;
    self.chartView.yMax = self.currentChart.yMax;
    self.chartView.data = @[self.currentChart.lineChartData];
}

#pragma mark - alternateDataPerios
-(void) addAlternateDataPeriodButtons {
    self.datePeriodSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Week", @"Month", @"6 Months", @"Year", @"All Time"]];

    self.datePeriodSegmentedControl.frame = CGRectMake(20, self.chartView.frame.origin.y + self.chartView.frame.size.height + 20, 280, 28);
    self.datePeriodSegmentedControl.selectedSegmentIndex = 1;
    [self.datePeriodSegmentedControl addTarget:self action:@selector(switchDataPeriods:) forControlEvents:UIControlEventValueChanged];
    [self.datePeriodSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:11.0], NSForegroundColorAttributeName: [UIColor blueColor]} forState:UIControlStateNormal];
	[self.view addSubview:self.datePeriodSegmentedControl];
}

-(void) switchDataPeriods:(id)sender{
    self.currentChart.dataPeriod = [self currentlySelectedDataPeriod];
    [self updateChartView];
}

-(DataPeriod) currentlySelectedDataPeriod {
    switch (self.datePeriodSegmentedControl.selectedSegmentIndex) {
        case 0:
            return DataPeriodWeek;
        case 1:
            return DataPeriodMonth;
        case 2:
            return DataPeriodSixMonth;
        case 3:
            return DataPeriodYear;
        default:
            return DataPeriodAllTime;
    }
}

-(void) addAlternateChartsPickerView {
    
    self.pickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TITLE_PICKER_WIDTH)/2, 10, TITLE_PICKER_WIDTH, 80)];
	self.pickerView.delegate    = self;
	self.pickerView.dataSource  = self;
	self.pickerView.selectionPoint = CGPointMake(60, 0);
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView setSelectedTextColor:[UIColor blueColor]];
    [self.pickerView setSelectionPoint:CGPointMake(TITLE_PICKER_WIDTH/2, 10)];
    
    [self.view addSubview:self.pickerView];
    [self.pickerView scrollToElement:0 animated:NO];
}

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return 3;
}


#pragma mark - V8HorizontalPickerViewDelegate

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[index];
    self.currentChart.dataPeriod = [self currentlySelectedDataPeriod];
    [self updateChartView];
}

- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    
    V8HorizontalPickerLabel* pickerViewLabel = [self createPickerViewLabel];
    [self populatePickerViewLabel:pickerViewLabel atIndex:index];
    
    return pickerViewLabel;
}

-(V8HorizontalPickerLabel*) createPickerViewLabel {
    V8HorizontalPickerLabel* pickerViewLabel = [[V8HorizontalPickerLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_PICKER_WIDTH,80)];
    [pickerViewLabel  setFont: [UIFont fontWithName:@"OCR A Extended" size:28.0]];
    [pickerViewLabel setTextAlignment:NSTextAlignmentCenter];
    pickerViewLabel.numberOfLines = 2;
    [pickerViewLabel setSelectedStateColor:[UIColor blueColor]];
    [pickerViewLabel setNormalStateColor:[UIColor grayColor]];
    return pickerViewLabel;
}

-(void) populatePickerViewLabel:(V8HorizontalPickerLabel*)pickerViewLabel atIndex:(NSInteger)index {
    
    if(self.pickerView.currentSelectedIndex == index) {
        [pickerViewLabel setSelectedElement:YES];
    }
    RWChart* chart = [RWChartDataManager sharedChartDataManager].charts[index];
    [pickerViewLabel setText:chart.title];
}

- (NSInteger)horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return TITLE_PICKER_WIDTH;
}

@end
