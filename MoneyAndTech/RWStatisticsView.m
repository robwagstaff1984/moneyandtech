//
//  RWStatisticsView.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/13/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWStatisticsView.h"
#import "RWChartDataManager.h"

#define PADDING 10
#define LINE_PADDING 25
#define LABEL_WIDTH 140

#define LABEL_LEFT_X PADDING
#define LABEL_RIGHT_X SCREEN_WIDTH - LABEL_WIDTH - LABEL_LEFT_X

#define ROW_ONE_Y 170
#define ROW_TWO_Y 220
#define ROW_THREE_Y 305
#define ROW_FOUR_Y 355
#define ROW_FIVE_Y 405

@interface RWStatisticsView()
@property (nonatomic, strong) UILabel* latestPriceLabel;
@end

@implementation RWStatisticsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupStatisticsView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    
    CGPoint lineSegments[] = {CGPointMake(LINE_PADDING, ROW_ONE_Y + 43), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_ONE_Y + 43),
        CGPointMake(LINE_PADDING, ROW_THREE_Y + 43), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_THREE_Y + 43), CGPointMake(LINE_PADDING, ROW_FOUR_Y + 43), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_FOUR_Y + 43), CGPointMake(160, ROW_ONE_Y -4), CGPointMake(160, ROW_TWO_Y + 42), CGPointMake(160, ROW_THREE_Y-4), CGPointMake(160, ROW_FIVE_Y + 42)};
    
    CGContextStrokeLineSegments(context, lineSegments, 10);
}

-(void) setupStatisticsView {
    
    self.backgroundColor = MONEY_AND_TECH_GREY;
    [self addLatestPriceLabel];
    
    [self addLabelWithHeading:@"Market cap" value:[RWChartDataManager sharedChartDataManager].marketCap atPoint:CGPointMake(LABEL_LEFT_X, ROW_ONE_Y)];
    [self addLabelWithHeading:@"Total Bitcoins" value:[RWChartDataManager sharedChartDataManager].totalBitcoinsInCirculation atPoint:CGPointMake(LABEL_RIGHT_X, ROW_ONE_Y)];
    [self addLabelWithHeading:@"Trade Volume BTC" value:[RWChartDataManager sharedChartDataManager].tradeVolumeBTC atPoint:CGPointMake(LABEL_LEFT_X, ROW_TWO_Y)];
    [self addLabelWithHeading:@"Trade Volume USD" value:[RWChartDataManager sharedChartDataManager].tradeVolumeUSD atPoint:CGPointMake(LABEL_RIGHT_X, ROW_TWO_Y)];
    
    [self addLabelWithHeading:@"Block Time" value:[RWChartDataManager sharedChartDataManager].blockTime atPoint:CGPointMake(LABEL_LEFT_X, ROW_THREE_Y)];
    [self addLabelWithHeading:@"Number of Transactions" value:[RWChartDataManager sharedChartDataManager].numberOfTransactions atPoint:CGPointMake(LABEL_RIGHT_X, ROW_THREE_Y)];
    [self addLabelWithHeading:@"Hash Rate" value:[RWChartDataManager sharedChartDataManager].hashRate atPoint:CGPointMake(LABEL_LEFT_X, ROW_FOUR_Y)];
    [self addLabelWithHeading:@"Difficulty" value:[RWChartDataManager sharedChartDataManager].difficulty atPoint:CGPointMake(LABEL_RIGHT_X, ROW_FOUR_Y)];
    [self addLabelWithHeading:@"Transaction Fees Per Day" value:[RWChartDataManager sharedChartDataManager].transactionFeesPerDay atPoint:CGPointMake(LABEL_LEFT_X, ROW_FIVE_Y)];
    [self addLabelWithHeading:@"Electricity Use Per Day" value:[RWChartDataManager sharedChartDataManager].electricityConsumputionPerDay atPoint:CGPointMake(LABEL_RIGHT_X, ROW_FIVE_Y)];
}

-(void) addLatestPriceLabel {
    self.latestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 100)];
    [self.latestPriceLabel setText:[RWChartDataManager sharedChartDataManager].latestPrice];
    [self.latestPriceLabel setFont: [UIFont boldSystemFontOfSize:60.0]];
    [self.latestPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.latestPriceLabel setTextColor:MONEY_AND_TECH_DARK_BLUE];
    [self addSubview:self.latestPriceLabel];
}

-(void) addLabelWithHeading:(NSString*)heading value:(NSString*)value atPoint:(CGPoint)point {
    
    UILabel* genericHeadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, LABEL_WIDTH, 20)];
    [genericHeadingLabel setText:heading];
    [genericHeadingLabel setFont: [UIFont systemFontOfSize:11.0]];
    [genericHeadingLabel setTextAlignment:NSTextAlignmentCenter];
    [genericHeadingLabel setTextColor:[UIColor darkGrayColor]];
    
    UILabel* genericValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y + 16, LABEL_WIDTH, 20)];
    [genericValueLabel setText:value];
    [genericValueLabel setFont: [UIFont systemFontOfSize:11.0]];
    [genericValueLabel setTextAlignment:NSTextAlignmentCenter];
    [genericValueLabel setTextColor:[UIColor blackColor]];
    
    [self addSubview:genericHeadingLabel];
    [self addSubview:genericValueLabel];
}

-(void) updatePrice {
    [self.latestPriceLabel setText:[RWChartDataManager sharedChartDataManager].latestPrice];
}

@end
