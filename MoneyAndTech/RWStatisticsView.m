//
//  RWStatisticsView.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/13/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWStatisticsView.h"
#import "RWChartDataManager.h"

#define LINE_PADDING (isIPad ? 25 : 18)
#define DEFAULT_LABEL_WIDTH ((SCREEN_WIDTH - LINE_PADDING - LINE_PADDING) / 2)
#define DEFAULT_LABEL_HEIGHT (isIPad ? 25 : 20)

#define LABEL_LEFT_X LINE_PADDING
#define LABEL_RIGHT_X MIDDLE_SCREEN_X
#define TOP_SECTION_VERTICAL_GAP (isIPad ? 15 : 7)
#define MIDDLE_SECTION_VERTICAL_GAP (isIPad ? 10 : 0)
#define BOTTOM_SECTION_VERTICAL_GAP (isIPad ? 15 : 7)
#define SECTION_VERTICAL_GAP (isIPad ? 16 : 10)
#define NETWORK_VERTICAL_GAP (isIPad ? 100 : 35)


#define CURRENT_PRICE_Y (isIPad ? 20 : 10)
#define CURRENT_PRICE_HEIGHT (isIPad ? 200 : 100)

#define ROW_ONE_Y (isIPad ? 330 : 135)
#define ROW_TWO_Y ROW_ONE_Y + ROW_HEIGHT
#define ROW_THREE_Y ROW_TWO_Y + ROW_HEIGHT + NETWORK_VERTICAL_GAP
#define ROW_FOUR_Y ROW_THREE_Y + ROW_HEIGHT
#define ROW_FIVE_Y ROW_FOUR_Y + ROW_HEIGHT

#define ROW_HEIGHT (TOP_SECTION_VERTICAL_GAP + DEFAULT_LABEL_HEIGHT + MIDDLE_SECTION_VERTICAL_GAP + DEFAULT_LABEL_HEIGHT + BOTTOM_SECTION_VERTICAL_GAP)
#define LINE_Y_POINT (ROW_HEIGHT - (isIPad ? 10 : 5))


#define MIDDLE_SCREEN_X (SCREEN_WIDTH / 2)

#define SMALL_LABEL_FONT [UIFont systemFontOfSize:isIPad? 28 : 11.0]
#define LARGE_LABEL_FONT [UIFont boldSystemFontOfSize:isIPad? 120 : 60.0]


@interface RWStatisticsView()
@property (nonatomic, strong) UILabel* latestPriceLabel;
@property (nonatomic, strong) UILabel* priceChangeLabel;
@property (nonatomic, strong) UIImageView* priceChangeArrow;
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
    
    CGPoint lineSegments[] = {CGPointMake(LINE_PADDING, ROW_ONE_Y + LINE_Y_POINT), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_ONE_Y + LINE_Y_POINT),
        CGPointMake(LINE_PADDING, ROW_THREE_Y + LINE_Y_POINT), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_THREE_Y + LINE_Y_POINT), CGPointMake(LINE_PADDING, ROW_FOUR_Y + LINE_Y_POINT), CGPointMake(SCREEN_WIDTH - LINE_PADDING, ROW_FOUR_Y + LINE_Y_POINT), CGPointMake(MIDDLE_SCREEN_X, ROW_ONE_Y), CGPointMake(MIDDLE_SCREEN_X, ROW_TWO_Y + ROW_HEIGHT), CGPointMake(MIDDLE_SCREEN_X, ROW_THREE_Y), CGPointMake(MIDDLE_SCREEN_X, ROW_FIVE_Y + ROW_HEIGHT)};
    
    CGContextStrokeLineSegments(context, lineSegments, 10);
}

-(void) setupStatisticsView {
    
    self.backgroundColor = MONEY_AND_TECH_GREY;
    [self addLatestPriceLabel];
    [self addPriceChangeLabel];
    
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
    self.latestPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CURRENT_PRICE_Y, SCREEN_WIDTH - 50, CURRENT_PRICE_HEIGHT)];
    [self.latestPriceLabel setText:[RWChartDataManager sharedChartDataManager].latestPrice];
    [self.latestPriceLabel setFont: LARGE_LABEL_FONT];
    [self.latestPriceLabel setTextAlignment:NSTextAlignmentCenter];
    [self.latestPriceLabel setTextColor:MONEY_AND_TECH_DARK_BLUE];
    [self addSubview:self.latestPriceLabel];
}

-(void) addPriceChangeLabel {
    self.priceChangeArrow = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, CURRENT_PRICE_Y + 54, 20, 20)];
    
    self.priceChangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 46, CURRENT_PRICE_Y + 58, 40, 18) ];
    [self.priceChangeLabel setFont:[UIFont systemFontOfSize:11]];

    [self addSubview:self.priceChangeLabel];
    [self addSubview:self.priceChangeArrow];
    [self updatePriceChange];
}

-(void) updatePriceChange {
    double percentChange = [RWChartDataManager sharedChartDataManager].percentChange;
    [self.priceChangeLabel setText:[NSString stringWithFormat:@"%.2f%%", percentChange]];
    
    if (percentChange >= 0) {
        [self.priceChangeLabel setTextColor:[UIColor colorWithRed:0 green:180.0/255.0 blue:0 alpha:1.0]];
        [self.priceChangeArrow setImage:[UIImage imageNamed:@"priceUpArrow.png"]];
    } else {
        [self.priceChangeLabel setTextColor:[UIColor colorWithRed:180/255.0 green:0/255.0 blue:0 alpha:1.0]];
        [self.priceChangeArrow setImage:[UIImage imageNamed:@"priceDownArrow.png"]];
    }
}

-(void) addLabelWithHeading:(NSString*)heading value:(NSString*)value atPoint:(CGPoint)point {

    UILabel* genericHeadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT)];
    [genericHeadingLabel setText:heading];
    [genericHeadingLabel setFont: SMALL_LABEL_FONT];
    [genericHeadingLabel setTextAlignment:NSTextAlignmentCenter];
    [genericHeadingLabel setTextColor:MONEY_AND_TECH_DARK_BLUE];
    
    UILabel* genericValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, genericHeadingLabel.frame.origin.y + genericHeadingLabel.frame.size.height + MIDDLE_SECTION_VERTICAL_GAP, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT)];
    [genericValueLabel setText:value];
    [genericValueLabel setFont: SMALL_LABEL_FONT];
    [genericValueLabel setTextAlignment:NSTextAlignmentCenter];
    [genericValueLabel setTextColor:[UIColor blackColor]];
    
    [self addSubview:genericHeadingLabel];
    [self addSubview:genericValueLabel];
}

-(void) updatePrice {
    [self.latestPriceLabel setText:[RWChartDataManager sharedChartDataManager].latestPrice];
    [self updatePriceChange];
}

@end
