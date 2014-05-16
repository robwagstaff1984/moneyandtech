//
//  UILabel+updateFrame.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/15/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "UILabel+updateFrame.h"

@implementation UILabel (updateFrame)

-(void) updateFrame {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self requiredFrameSize].size.width,  [self requiredFrameSize].size.height);
}

-(CGRect) requiredFrameSize {
    CGRect textSizeRect;
    textSizeRect.size = [self.text sizeWithAttributes:@{NSFontAttributeName: self.font}];
    return textSizeRect;
}

@end
