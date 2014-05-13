//
//  RWXAxisView.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/12/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWXAxisView.h"

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
    
    float startPoint = 44.0;
    float endPoint = SCREEN_WIDTH - 10;
    float quarterPoint = startPoint + ((endPoint - startPoint)*0.25);
    float halfPoint = startPoint + ((endPoint - startPoint)*0.5);
    float threeQuarterPoint = startPoint + ((endPoint - startPoint)*0.75);
    float distanceOfNotch = 10.0;
    
    CGPoint pointOneTop = CGPointMake(startPoint, 0);
    CGPoint pointTwoTop = CGPointMake(quarterPoint, 0);
    CGPoint pointTwoBottom = CGPointMake(quarterPoint, distanceOfNotch);
    CGPoint pointThreeTop = CGPointMake(halfPoint, 0);
    CGPoint pointThreeBottom = CGPointMake(halfPoint, distanceOfNotch);
    CGPoint pointFourTop = CGPointMake(threeQuarterPoint, 0);
    CGPoint pointFourBottom = CGPointMake(threeQuarterPoint, distanceOfNotch);
    CGPoint pointFiveTop = CGPointMake(endPoint, 0);
    
    CGPoint xAxisLines[] = { pointOneTop, pointTwoTop, pointTwoBottom, pointTwoTop, pointThreeTop, pointThreeBottom, pointThreeTop, pointFourTop, pointFourBottom, pointFourTop, pointFiveTop};
    
    CGContextSetLineWidth(context, 1.0);
    
    CGContextAddLines(context, xAxisLines, 11);

    CGContextStrokePath(context);
}

@end
