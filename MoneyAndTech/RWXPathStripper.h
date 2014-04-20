//
//  RWXPathStripper.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/30/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface RWXPathStripper : AFHTTPRequestOperationManager

+(NSString*) strippedHtmlFromVideosHTML:(NSData*)videosHTMLData;
+(NSString*) strippedHtmlFromArticlesHTML:(NSData*)articlesHTMLData;
+(NSString*) strippedHtmlFromNewsHTML:(NSData*)newsHTMLData;
@end
