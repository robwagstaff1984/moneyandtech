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
@property (nonatomic, strong) NSString* genericPostXPath;
@property (nonatomic, strong) NSString* newsPostXPath;
@property (nonatomic, strong) NSString* genericTitleXPath;
@property (nonatomic, strong) NSString* genericShareXPath;
@property (nonatomic, strong) NSString* genericTimeXPath;
@property (nonatomic, strong) NSString* videoXPath;
@property (nonatomic, strong) NSString* articleTextXPath;
@property (nonatomic, strong) NSString* newsBodyXPath;
@property (nonatomic, strong) NSString* forumPageXPath;

+(RWConfiguration*) sharedConfiguration;
-(void) setupParse;

@end
