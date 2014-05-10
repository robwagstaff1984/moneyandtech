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


@interface RWChartsViewController ()

@property (nonatomic, strong) LCLineChartView* chartView;
@property (nonatomic, strong) RWChart* currentChart;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UISegmentedControl *datePeriodSegmentedControl;

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
    [self setupActivityIndicator];
    [RWChartDataManager sharedChartDataManager].delegate = self;
    [[RWChartDataManager sharedChartDataManager] retrieveData];
}
-(void) setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
}

#pragma mark retrieve data

-(void) didFinishDownloadingChartData {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[0];
    [self setupStatisticsView];
    [self setupChartView];
    [self.activityIndicator stopAnimating];
}

#pragma mark - statistics view
-(void) setupStatisticsView {
    UIView* statisticsView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300, 100)];
    
    UILabel* currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 70)];
    [currentPriceLabel setText:[RWChartDataManager sharedChartDataManager].currentPrice];
    [currentPriceLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:36.0]];
    [currentPriceLabel setTextColor:[UIColor blueColor]];
    
    UILabel* marketCapLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 190, 20)];
    [marketCapLabel setText:[NSString stringWithFormat:@"Market cap: %@",[RWChartDataManager sharedChartDataManager].marketCap]];
    [marketCapLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [marketCapLabel setTextColor:[UIColor blueColor]];
    
    UILabel* tradeVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 24, 190, 20)];
    [tradeVolumeLabel setText:[NSString stringWithFormat:@"Trade volume: %@",[RWChartDataManager sharedChartDataManager].tradeVolume]];
    [tradeVolumeLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [tradeVolumeLabel setTextColor:[UIColor blueColor]];
    
    UILabel* hashRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 48, 190, 20)];
    [hashRateLabel setText:[NSString stringWithFormat:@"Hash rate: %@",[RWChartDataManager sharedChartDataManager].hashRate]];
    [hashRateLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [hashRateLabel setTextColor:[UIColor blueColor]];
    
    UILabel* blockRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 72, 190, 20)];
    [blockRateLabel setText:[NSString stringWithFormat:@"Block Time: %@",[RWChartDataManager sharedChartDataManager].blockTime]];
    [blockRateLabel setFont: [UIFont fontWithName:@"OCR A Extended" size:11.0]];
    [blockRateLabel setTextColor:[UIColor blueColor]];
    
    [statisticsView addSubview:currentPriceLabel];
    [statisticsView addSubview:marketCapLabel];
    [statisticsView addSubview:tradeVolumeLabel];
    [statisticsView addSubview:hashRateLabel];
    [statisticsView addSubview:blockRateLabel];
    [self.view addSubview:statisticsView];
}

#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];

    [self updateChartView];

    [self.view addSubview:self.chartView];
    [self addAlternateDataPeriodButtons];
    [self addAlternateChartButtons];

}

-(void) updateChartView {

    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.yMin = self.currentChart.yMin;
    self.chartView.yMax = self.currentChart.yMax;
    self.chartView.data = @[self.currentChart.lineChartData];
}

-(void) addAlternateDataPeriodButtons {
    self.datePeriodSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Week", @"Month", @"6 Months", @"Year", @"All Time"]];

    self.datePeriodSegmentedControl.frame = CGRectMake(20, self.chartView.frame.origin.y + self.chartView.frame.size.height, 280, 28);
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

-(void) addAlternateChartButtons {
    UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, self.datePeriodSegmentedControl.frame.origin.y + self.datePeriodSegmentedControl.frame.size.height, 280, 10 )];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    RWChart* chart = [RWChartDataManager sharedChartDataManager].charts[row];
    return chart.title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[row];
    self.currentChart.dataPeriod = [self currentlySelectedDataPeriod];
    [self updateChartView];
}

@end
