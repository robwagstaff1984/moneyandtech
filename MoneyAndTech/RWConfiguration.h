//
//  RWConfiguration.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/2/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWConfiguration : NSObject

@property (nonatomic, strong) NSString* homeURL;

+(RWConfiguration*) sharedConfiguration;
-(void) setupParse;

@end
