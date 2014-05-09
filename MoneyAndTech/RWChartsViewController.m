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
    [RWChartDataManager sharedChartDataManager].delegate = self;
    [[RWChartDataManager sharedChartDataManager] retrieveData];
}
#pragma mark retrieve data

-(void) didFinishDownloadingChartData {
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[0];
    [self setupChartView];
}

#pragma mark - chart view
-(void) setupChartView {

    self.chartView = [[LCLineChartView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
    self.chartView.yMin = 0;
    self.chartView.drawsDataPoints = NO;
    self.chartView.axisLabelColor = [UIColor blackColor];

    [self updateChartData];

    [self.view addSubview:self.chartView];
    [self addAlternateChartButtons];
}

-(void) updateChartData {
    self.chartView.yMax = self.currentChart.yMax;
    self.chartView.ySteps = self.currentChart.ySteps;
    self.chartView.data = @[self.currentChart.lineChartData];
}

-(void) switchCharts:(UIButton*)sender {
    NSLog(@"Switch charts to %d", sender.tag);
    self.currentChart = [RWChartDataManager sharedChartDataManager].charts[sender.tag];
    [self updateChartData];
}


-(void) addAlternateChartButtons {
    UIButton* marketPriceButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.chartView.frame.origin.y + self.chartView.frame.size.height + 40, 150, 44)];
    [marketPriceButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [marketPriceButton setTitle:@"Market Price" forState:UIControlStateNormal];
    marketPriceButton.tag = 0;
    [marketPriceButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:marketPriceButton];
    
    UIButton* numberOfTransactionsPerDayButton = [[UIButton alloc] initWithFrame:CGRectMake(20, marketPriceButton.frame.origin.y + marketPriceButton.frame.size.height + 40, 180, 44)];
    [numberOfTransactionsPerDayButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [numberOfTransactionsPerDayButton setTitle:@"Transactions Per Day" forState:UIControlStateNormal];
    numberOfTransactionsPerDayButton.tag = 1;
    [numberOfTransactionsPerDayButton addTarget:self action:@selector(switchCharts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:numberOfTransactionsPerDayButton];
}


@end
