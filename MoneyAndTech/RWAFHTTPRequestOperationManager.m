//
//  RWAFHTTPRequestOperationManager.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/29/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWAFHTTPRequestOperationManager.h"

@implementation RWAFHTTPRequestOperationManager

+(RWAFHTTPRequestOperationManager*) sharedRequestOperationManager {
    
    static RWAFHTTPRequestOperationManager* _sharedRequestOperationManager;
    if(!_sharedRequestOperationManager) {
        _sharedRequestOperationManager = [self new];
        _sharedRequestOperationManager = [RWAFHTTPRequestOperationManager manager];
        _sharedRequestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sharedRequestOperationManager;
}

+(RWAFHTTPRequestOperationManager*) sharedJSONRequestOperationManager {
    
    static RWAFHTTPRequestOperationManager* _sharedJSONRequestOperationManager;
    if(!_sharedJSONRequestOperationManager) {
        _sharedJSONRequestOperationManager = [self new];
        _sharedJSONRequestOperationManager = [RWAFHTTPRequestOperationManager manager];
    }
    return _sharedJSONRequestOperationManager;
}

@end
