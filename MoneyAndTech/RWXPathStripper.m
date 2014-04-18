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
#define VIDEOS_PAGE_TITLE_XPATH @"//h1[@class='entry-title']/a/text()"
#define VIDEOS_PAGE_SHARE_XPATH @"//div[@id='ssba']|//div[@class='ssba']"
#define VIDEOS_PAGE_TIME_XPATH @"//time[@pubdate]/text()"

#define HTML_HEAD @"<head></head>"
#define HTML_OPEN @"<html><body>"
#define HTML_CLOSE @"</body></html>"

@interface RWXPathStripper()
@property (nonatomic, strong) NSString* strippedVideosHTML;
@property (nonatomic, strong) NSMutableArray* videoHTMLElements;
@property (nonatomic, strong) NSMutableArray* titleHTMLElements;
@property (nonatomic, strong) NSMutableArray* shareHTMLElements;
@property (nonatomic, strong) NSMutableArray* timeHTMLElements;
@property (nonatomic, strong) TFHpple* videosPageParser;

@end

@implementation RWXPathStripper
#pragma mark - public methods

- (id)init
{
    self = [super init];
    if (self) {
        self.videoHTMLElements = [[NSMutableArray alloc] init];
        self.titleHTMLElements = [[NSMutableArray alloc] init];
        self.shareHTMLElements = [[NSMutableArray alloc] init];
        self.timeHTMLElements = [[NSMutableArray alloc] init];
    }
    return self;
}

+(NSString*) strippedHtmlFromVideosHTML:(NSData*)videosHTMLData {
    RWXPathStripper* xpathStripper = [[RWXPathStripper alloc] init];
    NSString* strippedVideosHTML = [xpathStripper strippedHtmlFromVideosHTML:videosHTMLData];
    strippedVideosHTML = [self nextPageFormatted:strippedVideosHTML];
    return strippedVideosHTML;
}

+(NSString*) nextPageFormatted:(NSString*)nextPageHTML {
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_HEAD withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_OPEN withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_CLOSE withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    return nextPageHTML;
}

-(NSString*) strippedHtmlFromVideosHTML:(NSData*)videosHTMLData {
    
    self.videosPageParser = [TFHpple hppleWithHTMLData:videosHTMLData];

    [self extractAllVideoElements];
    [self extractAllTitleElements];
    [self extractAllShareElements];
    [self extractAllTimeElements];
    
    [self constructStrippedVideosHTML];
    
    
    
    return self.strippedVideosHTML;
}

-(void) constructStrippedVideosHTML {
    self.strippedVideosHTML = HTML_OPEN;
    
    for (int articleNumber = 0; articleNumber < [self.videoHTMLElements count]; articleNumber++) {
        [self appendArticleNumber:articleNumber fromElementArray:self.titleHTMLElements];
        [self appendArticleNumber:articleNumber fromElementArray:self.videoHTMLElements];
        [self appendArticleNumber:articleNumber fromElementArray:self.shareHTMLElements];
        [self appendArticleNumber:articleNumber fromElementArray:self.timeHTMLElements];
    }
    self.strippedVideosHTML = [self.strippedVideosHTML stringByAppendingString:HTML_CLOSE];
}

-(void) appendArticleNumber:(int)articleNumber fromElementArray:(NSMutableArray*)elementArray {
    if ([elementArray count] > articleNumber) {
        self.strippedVideosHTML = [self.strippedVideosHTML stringByAppendingString:elementArray[articleNumber]];
    } else {
        NSLog(@"Warning. Missing Article Element");
    }
    
}

#pragma mark - video
-(void) extractAllVideoElements {
    NSString *videoElementXpathQueryString = VIDEOS_PAGE_VIDEO_XPATH;
    NSArray *videoNodes = [self.videosPageParser searchWithXPathQuery:videoElementXpathQueryString];
    
    for (TFHppleElement *videoElement in videoNodes) {
        [self.videoHTMLElements addObject:[self formattedVideoHTMLFromElement:videoElement]];
    }
}

-(NSString*) formattedVideoHTMLFromElement:(TFHppleElement*) element {
    
    NSString* formattedVideoElement = [self rawElementWithEndTag:element];
    formattedVideoElement = [self resizeformattedVideoElement:formattedVideoElement];
    formattedVideoElement = [self fixMalformedURLSourceForVideo:formattedVideoElement];
    return formattedVideoElement;
}

-(NSString*) rawElementWithEndTag:(TFHppleElement*)element {
    NSString* rawElementWithEndTag = [element.raw stringByReplacingOccurrencesOfString:@"/>" withString:[NSString stringWithFormat:@"></%@>", [element valueForKeyPath:@"node.nodeName"]]];
    return rawElementWithEndTag;
}

-(NSString*) resizeformattedVideoElement:(NSString*)formattedVideoElement {
    
    int originalHeight = [self originalHeightOfVideo:formattedVideoElement];
    int originalWidth = [self originalWidthOfVideo:formattedVideoElement];
    float originalRatio = (float)originalHeight / (float)originalWidth;
    int newWidth = SCREEN_WIDTH - 20;
    int newHeight = newWidth * originalRatio;
    
    formattedVideoElement = [self updateWidth:newWidth forFormattedVideoElement:formattedVideoElement];
    formattedVideoElement = [self updateHeight:newHeight forFormattedVideoElement:formattedVideoElement];
    
    return formattedVideoElement;
}

-(NSString*) fixMalformedURLSourceForVideo:(NSString*)formattedVideoElement {
    return [formattedVideoElement stringByReplacingOccurrencesOfString:@"src=\"//" withString:@"src=\"http://www."];
}

-(int) originalHeightOfVideo:(NSString*)formattedVideoElement {
    int originalHeight = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"height=\"(\\d*)\""];
    return originalHeight ?: 169;
}

-(int) originalWidthOfVideo:(NSString*)formattedVideoElement {
    int originalWidth = [self extractValueFromFormattedVideoElement:formattedVideoElement regexPattern:@"width=\"(\\d*)\""];
    return originalWidth ?: 309;
}

-(int) extractValueFromFormattedVideoElement:(NSString*)formattedVideoElement regexPattern:(NSString*)regexPattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match  = [regex firstMatchInString:formattedVideoElement options:0 range:NSMakeRange(0, [formattedVideoElement length])];
    NSRange matchRange = [match rangeAtIndex:1];
    NSString *matchString = [formattedVideoElement substringWithRange:matchRange];
    return [matchString intValue];
}

-(NSString*) updateWidth:(int)width forFormattedVideoElement:(NSString*)formattedVideoElement {
    return [self updateValue:width forFormattedVideoElement:formattedVideoElement regexPattern:@"(width=\")\\d*(\")"];;
}

-(NSString*) updateHeight:(int)height forFormattedVideoElement:(NSString*)formattedVideoElement {
    return [self updateValue:height forFormattedVideoElement:formattedVideoElement regexPattern:@"(height=\")\\d*(\")"];;
}

-(NSString*) updateValue:(int)value forFormattedVideoElement:(NSString*)formattedVideoElement regexPattern:(NSString*)regexPattern {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern options:NSRegularExpressionCaseInsensitive error:nil];
    formattedVideoElement = [regex stringByReplacingMatchesInString:formattedVideoElement
                                                            options:0
                                                              range:NSMakeRange(0, [formattedVideoElement length])
                                                       withTemplate:[NSString stringWithFormat:@"$1%d$2", value]];
    return formattedVideoElement;
}

#pragma mark - title
-(void) extractAllTitleElements {
    NSString *titleElementXpathQueryString = VIDEOS_PAGE_TITLE_XPATH;
    NSArray *titleNodes = [self.videosPageParser searchWithXPathQuery:titleElementXpathQueryString];
    
    for (TFHppleElement *titleElement in titleNodes) {
        [self.titleHTMLElements addObject:[self formattedTitleHTMLFromElement:titleElement]];
    }
}

-(NSString*) formattedTitleHTMLFromElement:(TFHppleElement*)titleElement {
    return [NSString stringWithFormat:@"<h3>%@</h3>", titleElement.raw];
}

#pragma mark - share

-(void) extractAllShareElements {
    NSString *shareElementXpathQueryString = VIDEOS_PAGE_SHARE_XPATH;
    NSArray *shareNodes = [self.videosPageParser searchWithXPathQuery:shareElementXpathQueryString];
    
    for (TFHppleElement *shareElement in shareNodes) {
        [self.shareHTMLElements addObject:[self formattedShareHTMLFromElement:shareElement]];
    }
}

-(NSString*) formattedShareHTMLFromElement:(TFHppleElement*)shareElement {
    
    NSString* shareElementFixed = [self fixMalformedURLSourceForShare:shareElement.raw];
    
    return [@"<div>&nbsp</div>" stringByAppendingString:shareElementFixed];
}

-(NSString*) fixMalformedURLSourceForShare:(NSString*)formattedShareElement {
    
    formattedShareElement = [formattedShareElement stringByReplacingOccurrencesOfString:@"src=\"/development" withString:[NSString stringWithFormat:@"src=\"%@/", MONEY_AND_TECH_HOME_PAGE_URL]];
    return [formattedShareElement stringByReplacingOccurrencesOfString:@"src=\"/" withString:[NSString stringWithFormat:@"src=\"%@/", MONEY_AND_TECH_HOME_PAGE_URL]];
}


#pragma mark - time

-(void) extractAllTimeElements {
    NSString *timeElementXpathQueryString = VIDEOS_PAGE_TIME_XPATH;
    NSArray *timeNodes = [self.videosPageParser searchWithXPathQuery:timeElementXpathQueryString];
    
    for (TFHppleElement *timeElement in timeNodes) {
        [self.timeHTMLElements addObject:[self formattedTimeHTMLFromElement:timeElement]];
    }
}

-(NSString*) formattedTimeHTMLFromElement:(TFHppleElement*)timeElement {
    return [NSString stringWithFormat:@"<div>%@</div>", timeElement.raw];
}

@end
