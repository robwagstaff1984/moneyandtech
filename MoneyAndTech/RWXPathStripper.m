//
//  RWXPathStripper.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/30/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWXPathStripper.h"
#import "TFHpple.h"

#define VIDEOS_PAGE_VIDEO_XPATH @"//iframe"

@implementation RWXPathStripper

+(NSString*) strippedHtmlFromVideosHTML:(NSData*)videosHTMLData {
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:videosHTMLData];
    
    NSString *tutorialsXpathQueryString = @"//iframe";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
   
    NSString* strippedVideosHTML = @"<html><body>";
    
    for (TFHppleElement *element in tutorialsNodes) {
        strippedVideosHTML = [strippedVideosHTML stringByAppendingString:@"<div>MyTitle</div>"];
        strippedVideosHTML = [strippedVideosHTML stringByAppendingString:[self formattedVideoHTMLFromElement:element]];
    }
    
    strippedVideosHTML = [strippedVideosHTML stringByAppendingString:@"</body></html>"];
    
    return strippedVideosHTML;
}

+(NSString*) formattedVideoHTMLFromElement:(TFHppleElement*) element {
    
    NSString* formattedVideoElement = [self rawElementWithEndTag:element];
    
    formattedVideoElement = [self resizeformattedVideoElement:formattedVideoElement];
    
    return formattedVideoElement;
}

+(NSString*) rawElementWithEndTag:(TFHppleElement*)element {
    return [element.raw stringByReplacingOccurrencesOfString:@"/>" withString:[NSString stringWithFormat:@"></%@>", [element valueForKeyPath:@"node.nodeName"]]];
}

+(NSString*) resizeformattedVideoElement:(NSString*)formattedVideoElement {
    
    formattedVideoElement = [formattedVideoElement stringByReplacingOccurrencesOfString:@"width=\"500\"" withString:@"width=\"320\""];
    formattedVideoElement = [formattedVideoElement stringByReplacingOccurrencesOfString:@"height=\"282\"" withString:@"height=\"180\""];

    int originalHeight = [self originalHeightOfVideo:formattedVideoElement];
    int originalWidth = [self originalWidthOfVideo:formattedVideoElement];
    
    return formattedVideoElement;
}

+(int) originalHeightOfVideo:(NSString*)formattedVideoElement {
    int originalHeight = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"height=\"(...)\""];
    return originalHeight ?: 169;
}

+(int) originalWidthOfVideo:(NSString*)formattedVideoElement {
    int originalWidth = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"width=\"(...)\""];
    return originalWidth ?: 300;
}

+(int) extractValueFromFormattedVideoElement:(NSString*)formattedVideoElement regexPattern:(NSString*)regexPattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match  = [regex firstMatchInString:formattedVideoElement options:0 range:NSMakeRange(0, [formattedVideoElement length])];
    NSRange matchRange = [match rangeAtIndex:1];
    NSString *matchString = [formattedVideoElement substringWithRange:matchRange];
    return [matchString integerValue];
}


@end
