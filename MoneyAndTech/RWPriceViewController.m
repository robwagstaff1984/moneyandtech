//
//  RWPriceViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPriceViewController.h"

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
    self.view.backgroundColor = [UIColor greenColor];
    [RWChartDataManager sharedChartDataManager].delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishDownloadingChartData)
                                                 name:BITCOIN_STATISTICS_DOWNLOADED
                                               object:nil];
}

-(void) didFinishDownloadingChartData {
    NSLog(@"didFinishDownloadingChartData Price;\n");
    [self setupStatisticsView];
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

@end
