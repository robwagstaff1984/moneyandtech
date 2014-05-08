//
//  RWChartDataItem.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/7/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWChartDataItem : NSObject

@property(nonatomic) int x;
@property(nonatomic) float y;
@property(nonatomic, strong) NSString* xLabel;
@property(nonatomic, strong) NSString* yLabel;

@end
