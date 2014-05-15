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
#import "RWXAxisView.h"
#import "UIViewController+ActivitySpinner.h"
#define TITLE_PICKER_WIDTH 320
#define ARROWS_AND_SPACE_WIDTH 32


@interface RWChartsViewController ()

@property (nonatomic, strong) LCLineChartView* chartView;
@property (nonatomic, strong) RWChart* currentChart;
@property (nonatomic, strong) UISegmentedControl *datePeriodSegmentedControl;
@property (nonatomic, strong) V8HorizontalPickerView* horizontalPickerView;
@property (nonatomic, strong) UIButton* leftChartArrow;
@property (nonatomic, strong) UIButton* rightChartArrow;
@property (nonatomic, strong) RWXAxisView* chartXAxis;
@property (nonatomic, strong) UIActivityIndicatorView* chartActivityIndicatorView;


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
    
    if (!self.currentChart) {
        self.currentChart = [RWChartDataManager sharedChartDataManager].charts[0];
        self.view.backgroundColor = MONEY_AND_TECH_GREY;
        [self addHorizontalChartsPickerView];
        [self addChartSwitchArrows];
        [self addAlternateDataPeriodButtons];
        [self setupChartView];
        [self setupChartXAxis];
        [self setDefaultChart];
        
        [self stopSpinner];
    }
}

-(void) setDefaultChart {

    self.datePeriodSegmentedControl.selectedSegmentIndex = 2;
    [self.horizontalPickerView scrollToElement:0 animated:NO];
}

#pragma mark - charts chooser
-(void) addHorizontalChartsPickerView {
    
    self.horizontalPickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - TITLE_PICKER_WIDTH)/2, 10 + NAV_BAR_HEIGHT, TITLE_PICKER_WIDTH, 80)];
	self.horizontalPickerView.delegate    = self;
	self.horizontalPickerView.dataSource  = self;
	self.horizontalPickerView.selectionPoint = CGPointMake(60, 0);
    [self.horizontalPickerView setBackgroundColor:MONEY_AND_TECH_GREY];
    [self.horizontalPickerView setSelectedTextColor:[UIColor blueColor]];
    [self.horizontalPickerView setSelectionPoint:CGPointMake(TITLE_PICKER_WIDTH/2, 10)];
    
    [self.view addSubview:self.horizontalPickerView];

}

- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return 3;
}

-(void) addChartSwitchArrows {
    self.leftChartArrow = [[UIButton alloc] initWithFrame:CGRectMake(8, 41, 16, 23)];
    [self.leftChartArrow setBackgroundImage:[UIImage imageNamed:@"LeftChartArrow.png"] forState:UIControlStateNormal];
    [self.leftChartArrow addTarget:self action:@selector(leftChartArrowTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightChartArrow = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 24, 41, 16, 23)];
    [self.rightChartArrow setBackgroundImage:[UIImage imageNamed:@"RightChartArrow.png"] forState:UIControlStateNormal];
        [self.rightChartArrow addTarget:self action:@selector(rightChartArrowTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self hideAndShowAppropriateArrows];
    [self.view addSubview:self.leftChartArrow];
    [self.view addSubview:self.rightChartArrow];
}

-(void) leftChartArrowTapped {
    [self.horizontalPickerView scrollToElement:self.horizontalPickerView.currentSelectedIndex - 1 animated:YES];
    [self hideAndShowAppropriateArrows];
}

-(void) rightChartArrowTapped {
    [self.horizontalPickerView scrollToElement:self.horizontalPickerView.currentSelectedIndex + 1 animated:YES];
    [self hideAndShowAppropriateArrows];
}

-(void) hideAndShowAppropriateArrows {
    self.leftChartArrow.hidden = self.horizontalPickerView.currentSelectedIndex == 0;
    self.rightChartArrow.hidden = self.horizontalPickerView.currentSelectedIndex == self.horizontalPickerView.numberOfElements - 1;
}

#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, self.datePeriodSegmentedControl.frame.origin.y + self.datePeriodSegmentedControl.frame.size.height + 25, SCREEN_WIDTH, SCREEN_WIDTH * 0.8)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];
    self.chartView.backgroundColor = MONEY_AND_TECH_GREY;
    
    [self.view addSubview:self.chartView];
    [self setupSpinner];
    
    [self updateChartView];
}

-(void) setupSpinner {
    self.chartActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
    self.chartActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.chartActivityIndicatorView.color = [UIColor blackColor];
    [self.view addSubview:self.chartActivityIndicatorView];
    
    self.chartActivityIndicatorView.center = self.view.center;
}

-(void) updateChartView {
    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.yMin = self.currentChart.yMin;
    self.chartView.yMax = self.currentChart.yMax;
    
    self.chartView.data = @[self.currentChart.lineChartData];
    
    self.chartXAxis.dataLabels = [self.currentChart xSteps];
    self.chartXAxis.startPoint = self.chartView.yAxisLabelsWidth + 8;
    [self.chartXAxis setNeedsDisplay];
    [self.chartActivityIndicatorView stopAnimating];
}

#pragma mark - chartXAxis
-(void) setupChartXAxis {
    self.chartXAxis = [[RWXAxisView alloc] initWithFrame:CGRectMake(0, self.chartView.frame.origin.y + self.chartView.frame.size.height + 1, SCREEN_WIDTH, 40)];

    self.chartXAxis.backgroundColor = MONEY_AND_TECH_GREY;
    self.chartXAxis.dataLabels = [self.currentChart xSteps];
    self.chartXAxis.startPoint = self.chartView.yAxisLabelsWidth + 8;
    [self.view addSubview:self.chartXAxis];
}

#pragma mark - alternateDataPerios
-(void) addAlternateDataPeriodButtons {
    self.datePeriodSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Week", @"Month", @"6 Months", @"Year", @"All Time"]];

    self.datePeriodSegmentedControl.frame = CGRectMake(20, self.horizontalPickerView.frame.origin.y + self.horizontalPickerView.frame.size.height + 15, 280, 28);
    [self.datePeriodSegmentedControl addTarget:self action:@selector(switchDataPeriods:) forControlEvents:UIControlEventValueChanged];
    [self.datePeriodSegmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:11.0], NSForegroundColorAttributeName: [UIColor blueColor]} forState:UIControlStateNormal];
	[self.view addSubview:self.datePeriodSegmentedControl];
}

-(void) switchDataPeriods:(id)sender{
    [self.chartActivityIndicatorView startAnimating];
    dispatch_after(0.01, dispatch_get_main_queue(), ^{
        self.currentChart.dataPeriod = [self currentlySelectedDataPeriod];
        [self updateChartView];
    });

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

#pragma mark - V8HorizontalPickerViewDelegate

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    
    [self.chartActivityIndicatorView startAnimating];
    dispatch_after(0.01, dispatch_get_main_queue(), ^{
        self.currentChart = [RWChartDataManager sharedChartDataManager].charts[index];
        self.currentChart.dataPeriod = [self currentlySelectedDataPeriod];
        [self updateChartView];
        [self hideAndShowAppropriateArrows];
    });
}

- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    
    V8HorizontalPickerLabel* pickerViewLabel = [self createPickerViewLabel];
    [self populatePickerViewLabel:pickerViewLabel atIndex:index];
    
    return pickerViewLabel;
}

-(V8HorizontalPickerLabel*) createPickerViewLabel {
    V8HorizontalPickerLabel* pickerViewLabel = [[V8HorizontalPickerLabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_PICKER_WIDTH,80)];
    [pickerViewLabel  setFont:[UIFont boldSystemFontOfSize:28]];
    [pickerViewLabel setTextAlignment:NSTextAlignmentCenter];
    pickerViewLabel.numberOfLines = 2;
    [pickerViewLabel setSelectedStateColor:MONEY_AND_TECH_DARK_BLUE];
    [pickerViewLabel setNormalStateColor:MONEY_AND_TECH_DARK_BLUE];
    return pickerViewLabel;
}

-(void) populatePickerViewLabel:(V8HorizontalPickerLabel*)pickerViewLabel atIndex:(NSInteger)index {
    
    if(self.horizontalPickerView.currentSelectedIndex == index) {
        [pickerViewLabel setSelectedElement:YES];
    }
    RWChart* chart = [RWChartDataManager sharedChartDataManager].charts[index];
    [pickerViewLabel setText:chart.title];
}

- (NSInteger)horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return TITLE_PICKER_WIDTH;
}

- (NSString *)tabImageName
{
    return @"ChartsIcon";
}

- (NSString *)tabTitle
{
    return @"Charts";
}

@end
