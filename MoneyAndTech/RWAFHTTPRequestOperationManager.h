//
//  RWAFHTTPRequestOperationManager.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/29/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface RWAFHTTPRequestOperationManager : AFHTTPRequestOperationManager

+(RWAFHTTPRequestOperationManager*) sharedRequestOperationManager;

@end
