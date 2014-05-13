//
//  RWXAxisView.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/12/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWXAxisView.h"

#define DISTANCE_OF_NOTCH 10.0

@interface RWXAxisView()

@property (nonatomic, strong) UILabel* quarterPointLabel;
@property (nonatomic, strong) UILabel* halfPointLabel;
@property (nonatomic, strong) UILabel* threeQuarterPointLabel;
@end

@implementation RWXAxisView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataLabels = [[NSArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context    = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGPoint pointOneTop = CGPointMake(self.startPoint, 0);
    CGPoint pointTwoTop = CGPointMake(self.quarterPoint, 0);
    CGPoint pointTwoBottom = CGPointMake(self.quarterPoint, DISTANCE_OF_NOTCH);
    CGPoint pointThreeTop = CGPointMake(self.halfPoint, 0);
    CGPoint pointThreeBottom = CGPointMake(self.halfPoint, DISTANCE_OF_NOTCH);
    CGPoint pointFourTop = CGPointMake(self.threeQuarterPoint, 0);
    CGPoint pointFourBottom = CGPointMake(self.threeQuarterPoint, DISTANCE_OF_NOTCH);
    CGPoint pointFiveTop = CGPointMake(self.endPoint, 0);
    
    CGPoint xAxisLines[] = { pointOneTop, pointTwoTop, pointTwoBottom, pointTwoTop, pointThreeTop, pointThreeBottom, pointThreeTop, pointFourTop, pointFourBottom, pointFourTop, pointFiveTop};
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextAddLines(context, xAxisLines, 11);

    CGContextStrokePath(context);
    [self setupLabels];
}

-(void) setupLabels {
    self.quarterPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.quarterPoint - 30, DISTANCE_OF_NOTCH, 60, 15)];
    [self.quarterPointLabel setTextAlignment:NSTextAlignmentCenter];
    [self.quarterPointLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.quarterPointLabel];
    
    self.halfPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.halfPoint - 30, DISTANCE_OF_NOTCH, 60, 15)];
    [self.halfPointLabel setTextAlignment:NSTextAlignmentCenter];
    [self.halfPointLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.halfPointLabel];
    
    self.threeQuarterPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.threeQuarterPoint - 30, DISTANCE_OF_NOTCH, 60, 15)];
    [self.threeQuarterPointLabel setTextAlignment:NSTextAlignmentCenter];
    [self.threeQuarterPointLabel setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.threeQuarterPointLabel];

    [self updateLabels];
}

-(float) startPoint {
    return 44.0;
}

-(float) endPoint {
    return SCREEN_WIDTH - 10;
}

-(float) quarterPoint {
    return self.startPoint + ((self.endPoint - self.startPoint)*0.25);
}

-(float) halfPoint {
    return self.startPoint + ((self.endPoint - self.startPoint)*0.50);
}

-(float) threeQuarterPoint {
    return self.startPoint + ((self.endPoint - self.startPoint)*0.75);
}

-(void) setDataLabels:(NSArray *)dataLabels {
    _dataLabels = dataLabels;
    [self updateLabels];
}

-(void) updateLabels {
    self.quarterPointLabel.text = self.dataLabels[1];
    self.halfPointLabel.text = self.dataLabels[2];
    self.threeQuarterPointLabel.text = self.dataLabels[3];
}

@end
