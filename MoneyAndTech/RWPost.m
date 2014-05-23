//
//  RWArticle.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 4/18/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWPost.h"

@implementation RWPost

- (id)init
{
    self = [super init];
    if (self) {
        self.titleHTML = @"";
        self.shareHTML = @"";
        self.timeHTML = @"";
        self.sourceHTML = @"";
    }
    return self;
}

@end
