//
//  RWRegexHTMLStripper.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/20/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWRegexHTMLStripper : NSObject

+(NSString*) strippedHtmlFromVideosHTML:(NSString*)videosHTML;
@end
