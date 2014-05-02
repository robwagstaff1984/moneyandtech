//
//  RWConfiguration.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/2/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWConfiguration.h"
#import <Parse/Parse.h>

@implementation RWConfiguration

+(RWConfiguration*) sharedConfiguration {
    
    static RWConfiguration* _sharedConfiguration;
    if(!_sharedConfiguration) {
        _sharedConfiguration = [self new];
    }
    return _sharedConfiguration;
}

-(void) setupParse {
    [Parse setApplicationId:@"sfgZq1Me3Z6AXgVktP3Yb6RFaW0AhxwI3Yv9wtk8" clientKey:@"IAhDDnpjSOvb2tu6UneXvwhDV9Yz5tObRxHhThmB"];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    [self retrieveParseConfiguration];
}

-(void) retrieveParseConfiguration {
    PFQuery *query = [PFQuery queryWithClassName:@"Configuration"];
    PFObject* parseConfiguration = [query getFirstObject]; //TODO make it run in background
    
    [[RWConfiguration sharedConfiguration] setShouldReformatVideosPage: [parseConfiguration[@"shouldReformatVideosPage"] boolValue]];
    [[RWConfiguration sharedConfiguration] setShouldReformatArticlesPage: [parseConfiguration[@"shouldReformatArticlesPage"] boolValue]];
    [[RWConfiguration sharedConfiguration] setShouldReformatNewsPage: [parseConfiguration[@"shouldReformatNewsPage"] boolValue]];
    [[RWConfiguration sharedConfiguration] setHomeURL: parseConfiguration[@"homeURL"]];
    [[RWConfiguration sharedConfiguration] setGenericPostXPath: parseConfiguration[@"genericPostXPath"]];
    [[RWConfiguration sharedConfiguration] setNewsPostXPath: parseConfiguration[@"newsPostXPath"]];
    [[RWConfiguration sharedConfiguration] setGenericTitleXPath: parseConfiguration[@"genericTitleXPath"]];
    [[RWConfiguration sharedConfiguration] setGenericShareXPath: parseConfiguration[@"genericShareXPath"]];
    [[RWConfiguration sharedConfiguration] setGenericTimeXPath: parseConfiguration[@"genericTimeXPath"]];
    [[RWConfiguration sharedConfiguration] setVideoXPath: parseConfiguration[@"videoXPath"]];
    [[RWConfiguration sharedConfiguration] setArticleTextXPath: parseConfiguration[@"articleTextXPath"]];
    [[RWConfiguration sharedConfiguration] setNewsBodyXPath: parseConfiguration[@"newsBodyXPath"]];
    [[RWConfiguration sharedConfiguration] setForumPageXPath: parseConfiguration[@"forumPageXPath"]];
}

@end
