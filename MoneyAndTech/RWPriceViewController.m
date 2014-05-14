//
//  RWPriceViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPriceViewController.h"

#define LABEL_LEFT_X 10
#define LABEL_RIGHT_X 170

@implementation RWPriceViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Price";
    }
    return self;
}

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownloadingChartData) name:BITCOIN_STATISTICS_DOWNLOADED object:nil];
    [self startSpinner];
}

-(void) didFinishDownloadingChartData {
    NSLog(@"didFinishDownloadingChartData Price;\n");
    [self setupStatisticsView];
    [self stopSpinner];
}

#pragma mark - statistics view
-(void) setupStatisticsView {
    
    [self addLatestPriceLabel];
    
    [self addLabelWithHeading:@"Market cap" value:[RWChartDataManager sharedChartDataManager].marketCap atPoint:CGPointMake(LABEL_LEFT_X, 180)];
    [self addLabelWithHeading:@"Total Bitcoins" value:[RWChartDataManager sharedChartDataManager].totalBitcoinsInCirculation atPoint:CGPointMake(LABEL_RIGHT_X, 180)];
    [self addLabelWithHeading:@"Trade Volume BTC" value:[RWChartDataManager sharedChartDataManager].tradeVolumeBTC atPoint:CGPointMake(LABEL_LEFT_X, 230)];
    [self addLabelWithHeading:@"Trade Volume USD" value:[RWChartDataManager sharedChartDataManager].tradeVolumeUSD atPoint:CGPointMake(LABEL_RIGHT_X, 230)];
    
    [self addLabelWithHeading:@"Block Time" value:[RWChartDataManager sharedChartDataManager].blockTime atPoint:CGPointMake(LABEL_LEFT_X, 305)];
    [self addLabelWithHeading:@"Number of Transactions" value:[RWChartDataManager sharedChartDataManager].numberOfTransactions atPoint:CGPointMake(LABEL_RIGHT_X, 305)];
    [self addLabelWithHeading:@"Hash Rate" value:[RWChartDataManager sharedChartDataManager].hashRate atPoint:CGPointMake(LABEL_LEFT_X, 355)];
    [self addLabelWithHeading:@"Difficulty" value:[RWChartDataManager sharedChartDataManager].difficulty atPoint:CGPointMake(LABEL_RIGHT_X, 355)];
    [self addLabelWithHeading:@"Transaction Fees Per Day" value:[RWChartDataManager sharedChartDataManager].transactionFeesPerDay atPoint:CGPointMake(LABEL_LEFT_X, 405)];
    [self addLabelWithHeading:@"Electricity Use Per Day" value:[RWChartDataManager sharedChartDataManager].electricityConsumputionPerDay atPoint:CGPointMake(LABEL_RIGHT_X, 405)];
}

-(void) addLatestPriceLabel {
    UILabel* latestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 100)];
    [latestPriceLabel setText:[RWChartDataManager sharedChartDataManager].latestPrice];
    [latestPriceLabel setFont: [UIFont boldSystemFontOfSize:60.0]];
    [latestPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [latestPriceLabel setTextColor:MONEY_AND_TECH_DARK_BLUE];
    [self.view addSubview:latestPriceLabel];
}

-(void) addLabelWithHeading:(NSString*)heading value:(NSString*)value atPoint:(CGPoint)point {
    
    UILabel* genericHeadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 140, 20)];
    [genericHeadingLabel setText:heading];
    [genericHeadingLabel setFont: [UIFont systemFontOfSize:11.0]];
    [genericHeadingLabel setTextAlignment:NSTextAlignmentCenter];
    [genericHeadingLabel setTextColor:[UIColor darkGrayColor]];
    
     UILabel* genericValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y + 16, 140, 20)];
    [genericValueLabel setText:value];
    [genericValueLabel setFont: [UIFont systemFontOfSize:11.0]];
    [genericValueLabel setTextAlignment:NSTextAlignmentCenter];
    [genericValueLabel setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:genericHeadingLabel];
    [self.view addSubview:genericValueLabel];
}

@end
