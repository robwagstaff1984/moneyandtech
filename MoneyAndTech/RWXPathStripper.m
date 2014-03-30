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
#pragma mark - public methods
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

#pragma mark - video
+(NSString*) formattedVideoHTMLFromElement:(TFHppleElement*) element {
    
    NSString* formattedVideoElement = [self rawElementWithEndTag:element];
    formattedVideoElement = [self resizeformattedVideoElement:formattedVideoElement];
    return formattedVideoElement;
}

+(NSString*) rawElementWithEndTag:(TFHppleElement*)element {
    return [element.raw stringByReplacingOccurrencesOfString:@"/>" withString:[NSString stringWithFormat:@"></%@>", [element valueForKeyPath:@"node.nodeName"]]];
}

+(NSString*) resizeformattedVideoElement:(NSString*)formattedVideoElement {
    
    int originalHeight = [self originalHeightOfVideo:formattedVideoElement];
    int originalWidth = [self originalWidthOfVideo:formattedVideoElement];
    float originalRatio = (float)originalHeight / (float)originalWidth;
    int newWidth = SCREEN_WIDTH - 20;
    int newHeight = newWidth * originalRatio;
    
    formattedVideoElement = [self updateWidth:newWidth forFormattedVideoElement:formattedVideoElement];
    formattedVideoElement = [self updateHeight:newHeight forFormattedVideoElement:formattedVideoElement];
    
    return formattedVideoElement;
}

+(int) originalHeightOfVideo:(NSString*)formattedVideoElement {
    int originalHeight = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"height=\"(\\d*)\""];
    return originalHeight ?: 169;
}

+(int) originalWidthOfVideo:(NSString*)formattedVideoElement {
    int originalWidth = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"width=\"(\\d*)\""];
    return originalWidth ?: 309;
}

+(int) extractValueFromFormattedVideoElement:(NSString*)formattedVideoElement regexPattern:(NSString*)regexPattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match  = [regex firstMatchInString:formattedVideoElement options:0 range:NSMakeRange(0, [formattedVideoElement length])];
    NSRange matchRange = [match rangeAtIndex:1];
    NSString *matchString = [formattedVideoElement substringWithRange:matchRange];
    return [matchString integerValue];
}

+(NSString*) updateWidth:(int)width forFormattedVideoElement:(NSString*)formattedVideoElement {
    return [self updateValue:width forFormattedVideoElement:formattedVideoElement regexPattern:@"(width=\")\\d*(\")"];;
}

+(NSString*) updateHeight:(int)height forFormattedVideoElement:(NSString*)formattedVideoElement {
    return [self updateValue:height forFormattedVideoElement:formattedVideoElement regexPattern:@"(height=\")\\d*(\")"];;
}

+(NSString*) updateValue:(int)value forFormattedVideoElement:(NSString*)formattedVideoElement regexPattern:(NSString*)regexPattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    formattedVideoElement = [regex stringByReplacingMatchesInString:formattedVideoElement
                                                            options:0
                                                              range:NSMakeRange(0, [formattedVideoElement length])
                                                       withTemplate:[NSString stringWithFormat:@"$1%d$2", value]];
    return formattedVideoElement;
}

@end
