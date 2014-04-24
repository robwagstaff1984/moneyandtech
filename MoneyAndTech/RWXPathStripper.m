//
//  RWXPathStripper.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/30/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWXPathStripper.h"
#import "TFHpple.h"
#import "RWVideoPost.h"
#import "RWArticlePost.h"
#import "RWNewsPost.h"

#define GENERIC_POST_XPATH @"//article"
#define NEWS_POST_XPATH @"//div[@class='rss-output']"
#define VIDEOS_PAGE_VIDEO_XPATH @"//iframe"
#define VIDEOS_PAGE_TITLE_XPATH @"//*[@class='entry-title']/a/text()|//div[@class='title']/span/a/text()"
#define VIDEOS_PAGE_SHARE_XPATH @"//div[@id='ssba']|//div[@class='ssba']"
#define VIDEOS_PAGE_TIME_XPATH @"//time[@pubdate]/text()|//span[@class='date']/text()"
#define ARTICLE_TEXT_XPATH @"//div[@class='entry-content']"
#define FORUM_PAGE_XPATH @"//html"

#define HTML_HEAD @"<head></head>"
#define HTML_OPEN @"<html><body>"
#define HTML_CLOSE @"</body></html>"

@interface RWXPathStripper()

@property (nonatomic, strong) NSMutableArray* videoPosts;
@property (nonatomic, strong) NSMutableArray* articlePosts;
@property (nonatomic, strong) NSMutableArray* newsPosts;

@property (nonatomic, strong) TFHpple* pageParser;

@end

@implementation RWXPathStripper
#pragma mark - public methods

- (id)init
{
    self = [super init];
    if (self) {
        self.videoPosts = [[NSMutableArray alloc] init];
        self.articlePosts = [[NSMutableArray alloc] init];
        self.newsPosts = [[NSMutableArray alloc] init];
    }
    return self;
}

+(NSString*) strippedHtmlFromVideosHTML:(NSData*)videosHTMLData {
    RWXPathStripper* xpathStripper = [[RWXPathStripper alloc] init];
    NSString* strippedVideosHTML = [xpathStripper strippedHtmlFromVideosHTMLData:videosHTMLData];
    strippedVideosHTML = [self nextPageFormatted:strippedVideosHTML];
    return strippedVideosHTML;
}

+(NSString*) strippedHtmlFromArticlesHTML:(NSData*)articlesHTMLData {
    RWXPathStripper* xpathStripper = [[RWXPathStripper alloc] init];
    NSString* strippedArticlesHTML = [xpathStripper strippedHtmlFromArticlesHTMLData:articlesHTMLData];
    strippedArticlesHTML = [self nextPageFormatted:strippedArticlesHTML];
    return strippedArticlesHTML;
}

+(NSString*) strippedHtmlFromNewsHTML:(NSData*)newsHTMLData {
    RWXPathStripper* xpathStripper = [[RWXPathStripper alloc] init];
    NSString* strippedNewsHTML = [xpathStripper strippedHtmlFromNewsHTMLData:newsHTMLData];
    strippedNewsHTML = [self nextPageFormatted:strippedNewsHTML];
    return strippedNewsHTML;
}

+(NSString*) strippedHtmlFromForumHTML:(NSData*)forumHTMLData {
    RWXPathStripper* xpathStripper = [[RWXPathStripper alloc] init];
    NSString* strippedForumHTML = [xpathStripper strippedHtmlFromForumHTMLData:forumHTMLData];
    strippedForumHTML = [self nextPageFormatted:strippedForumHTML];
    return strippedForumHTML;
}

+(NSString*) nextPageFormatted:(NSString*)nextPageHTML {
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_HEAD withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_OPEN withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:HTML_CLOSE withString:@""];
    nextPageHTML = [nextPageHTML stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    return nextPageHTML;
}

-(NSString*) strippedHtmlFromVideosHTMLData:(NSData*)videosHTMLData {
    
    self.pageParser = [TFHpple hppleWithHTMLData:videosHTMLData];
    
    int totalPosts = [self countOfPostsFromHTMLData:videosHTMLData];
    for (int postNumber = 0; postNumber < totalPosts; postNumber++) {
        RWVideoPost* videoPost = [RWVideoPost new];
        [self extractTitleElementfromPostNumber:postNumber intoPost:videoPost];
        [self extractVideoElementfromPostNumber:postNumber intoPost:videoPost];
        [self extractShareElementfromPostNumber:postNumber intoPost:videoPost];
        [self extractTimeElementfromPostNumber:postNumber intoPost:videoPost];
        [self.videoPosts addObject:videoPost];
    }
    
    NSString* strippedVideosHTML = [self constructStrippedVideosHTML];
    
    return strippedVideosHTML;
}

-(NSString*) strippedHtmlFromArticlesHTMLData:(NSData*)articlesHTMLData {
    
    self.pageParser = [TFHpple hppleWithHTMLData:articlesHTMLData];
    
    int totalPosts = [self countOfPostsFromHTMLData:articlesHTMLData];
    for (int postNumber = 0; postNumber < totalPosts; postNumber++) {
        RWArticlePost* articlePost = [RWArticlePost new];
        [self extractTitleElementfromPostNumber:postNumber intoPost:articlePost];
        [self extractArticleElementfromPostNumber:postNumber intoPost:articlePost];
//        [self extractShareElementfromPostNumber:postNumber intoPost:articlePost];
//        [self extractTimeElementfromPostNumber:postNumber intoPost:articlePost];
        [self.articlePosts addObject:articlePost];
    }
    
    NSString* strippedArticlesHMTL = [self constructStrippedArticleHTML];
    return strippedArticlesHMTL;
}

-(NSString*) strippedHtmlFromNewsHTMLData:(NSData*)newsHTMLData {
    self.pageParser = [TFHpple hppleWithHTMLData:newsHTMLData];
    
    int totalPosts = [self countOfPostsFromHTMLData:newsHTMLData];
    for (int postNumber = 0; postNumber < totalPosts; postNumber++) {
        RWNewsPost* newsPost = [RWNewsPost new];
        [self extractTitleElementfromPostNumber:postNumber intoPost:newsPost];
        [self extractShareElementfromPostNumber:postNumber intoPost:newsPost];
        [self extractTimeElementfromPostNumber:postNumber intoPost:newsPost];
        [self.newsPosts addObject:newsPost];
    }
    
    NSString* strippedNewsHMTL = [self constructStrippedNewsHTML];
    return strippedNewsHMTL;
}

-(NSString*) strippedHtmlFromForumHTMLData:(NSData*)forumHTMLData {
    self.pageParser = [TFHpple hppleWithHTMLData:forumHTMLData];
    NSString* unformatedForumHTML =  [self extractUnformatedForumHTML];
    return unformatedForumHTML;
}



-(int) countOfPostsFromHTMLData:(NSData*)htmlData {
    TFHpple* genericPostParser = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *genericPostNodes = [genericPostParser searchWithXPathQuery:GENERIC_POST_XPATH];
    NSArray *newsPostNodes = [genericPostParser searchWithXPathQuery:NEWS_POST_XPATH];
    
    return MAX((int)[genericPostNodes count], (int)[newsPostNodes count]);
}


-(NSString*) constructStrippedVideosHTML {
    NSString* strippedVideosHTML = HTML_OPEN;
    
    for (int postNumber = 0; postNumber < [self.videoPosts count]; postNumber++) {
        strippedVideosHTML = [self appendVideoPostNumber:postNumber toVideoHTML:strippedVideosHTML];
    }
    strippedVideosHTML = [strippedVideosHTML stringByAppendingString:HTML_CLOSE];
    return strippedVideosHTML;
}

-(NSString*) appendVideoPostNumber:(int)postNumber toVideoHTML:(NSString*)videoHTML {
    RWVideoPost* videoPost = self.videoPosts[postNumber];
    videoHTML = [videoHTML stringByAppendingString:videoPost.titleHTML];
    videoHTML = [videoHTML stringByAppendingString:videoPost.videoHTML];
    videoHTML = [videoHTML stringByAppendingString:[self combinedHTMLForTime:videoPost.timeHTML andShare:videoPost.shareHTML]];

    return videoHTML;
}

-(NSString*) combinedHTMLForTime:(NSString*)timeHTML andShare:(NSString*)shareHTML {
    return [NSString stringWithFormat:@"<div style=\"border-bottom: 1px solid darkgray; padding: 12px 5px 10px 5px; height:56px;\">%@%@</div><div style=\"clear: both;\"></div>", timeHTML, shareHTML];
}

-(NSString*) constructStrippedArticleHTML {
    NSString* strippedVideosHTML = HTML_OPEN;
    
    for (int postNumber = 0; postNumber < [self.articlePosts count]; postNumber++) {
        strippedVideosHTML = [self appendArticlePostNumber:postNumber toArticleHTML:strippedVideosHTML];
    }
    strippedVideosHTML = [strippedVideosHTML stringByAppendingString:HTML_CLOSE];
    return strippedVideosHTML;
}

-(NSString*) appendArticlePostNumber:(int)postNumber toArticleHTML:(NSString*)articleHTML {
    RWArticlePost* articlePost = self.articlePosts[postNumber];
    articleHTML = [articleHTML stringByAppendingString:articlePost.titleHTML];
    articleHTML = [articleHTML stringByAppendingString:articlePost.articleHTML];
    articleHTML = [articleHTML stringByAppendingString:[self combinedHTMLForTime:articlePost.timeHTML andShare:articlePost.shareHTML]];

    return articleHTML;
}

-(NSString*) constructStrippedNewsHTML {
    NSString* strippedNewsHTML = HTML_OPEN;
    
    for (int postNumber = 0; postNumber < [self.newsPosts count]; postNumber++) {
        strippedNewsHTML = [self appendNewsPostNumber:postNumber toNewsHTML:strippedNewsHTML];
    }
    strippedNewsHTML = [strippedNewsHTML stringByAppendingString:HTML_CLOSE];
    return strippedNewsHTML;
}

-(NSString*) appendNewsPostNumber:(int)postNumber toNewsHTML:(NSString*)newsHTML {
    RWNewsPost* newsPost = self.newsPosts[postNumber];
    newsHTML = [newsHTML stringByAppendingString:newsPost.titleHTML];
//    newsHTML = [newsHTML stringByAppendingString:newsPost.shareHTML];
    newsHTML = [newsHTML stringByAppendingString:newsPost.timeHTML];
    return newsHTML;
}

#pragma mark - video

-(void) extractVideoElementfromPostNumber:(int)postNumber intoPost:(RWVideoPost*)videoPost {
    NSArray *videoNodes = [self.pageParser searchWithXPathQuery:VIDEOS_PAGE_VIDEO_XPATH];
    TFHppleElement *videoElement = [videoNodes count] > postNumber ? videoNodes[postNumber] : nil;
    
    if (videoPost != nil && videoElement != nil) {
        videoPost.videoHTML = [self formattedVideoHTMLFromElement:videoElement];
    }
}

-(NSString*) formattedVideoHTMLFromElement:(TFHppleElement*) element {
    
    NSString* formattedVideoElement = [self rawElementWithEndTag:element];
    formattedVideoElement = [self resizeAssetsToFitFromHTML:formattedVideoElement];
    formattedVideoElement = [self fixMalformedURLSourceForVideo:formattedVideoElement];
    return formattedVideoElement;
}

-(NSString*) rawElementWithEndTag:(TFHppleElement*)element {
    NSString* rawElementWithEndTag = [element.raw stringByReplacingOccurrencesOfString:@"/>" withString:[NSString stringWithFormat:@"></%@>", [element valueForKeyPath:@"node.nodeName"]]];
    return rawElementWithEndTag;
}

-(NSString*) resizeAssetsToFitFromHTML:(NSString*)htmlToBeFormatted {
    
    int originalHeight = [self originalHeightOfVideo:htmlToBeFormatted];
    int originalWidth = [self originalWidthOfVideo:htmlToBeFormatted];
    
    if (originalWidth > 300) {
        float originalRatio = (float)originalHeight / (float)originalWidth;
        int newWidth = SCREEN_WIDTH - 20;
        int newHeight = newWidth * originalRatio;
        
        htmlToBeFormatted = [self updateWidth:newWidth forFormattedVideoElement:htmlToBeFormatted];
        htmlToBeFormatted = [self updateHeight:newHeight forFormattedVideoElement:htmlToBeFormatted];
    }
    
    return htmlToBeFormatted;
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
-(void) extractTitleElementfromPostNumber:(int)postNumber intoPost:(RWPost*)post {
    NSArray *titleNodes = [self.pageParser searchWithXPathQuery:VIDEOS_PAGE_TITLE_XPATH];
    TFHppleElement *titleElement = [titleNodes count] > postNumber ? titleNodes[postNumber] : nil;
    
    if (post != nil && titleElement != nil) {
        post.titleHTML = [self formattedTitleHTMLFromElement:titleElement];
    }
}

-(NSString*) formattedTitleHTMLFromElement:(TFHppleElement*)titleElement {
    return [NSString stringWithFormat:@"<h3>%@</h3>", titleElement.raw];
}

#pragma mark - share

-(void) extractShareElementfromPostNumber:(int)postNumber intoPost:(RWPost*)post {
    NSArray *shareNodes = [self.pageParser searchWithXPathQuery:VIDEOS_PAGE_SHARE_XPATH];
    TFHppleElement *shareElement = [shareNodes count] > postNumber ? shareNodes[postNumber] : nil;
    
    if (post != nil && shareElement != nil) {
        post.shareHTML = [self formattedShareHTMLFromElement:shareElement];
    }
}

-(NSString*) formattedShareHTMLFromElement:(TFHppleElement*)shareElement {
    
    NSString* shareElementFixed = [self fixMalformedURLSourceForShare:shareElement.raw];
    
    return [NSString stringWithFormat:@"<span style=\"display:inline-block;float:right\">%@</span>", shareElementFixed];
}

-(NSString*) fixMalformedURLSourceForShare:(NSString*)formattedShareElement {
    
    formattedShareElement = [formattedShareElement stringByReplacingOccurrencesOfString:@"src=\"/development" withString:[NSString stringWithFormat:@"src=\"%@/", MONEY_AND_TECH_HOME_PAGE_URL]];
    return [formattedShareElement stringByReplacingOccurrencesOfString:@"src=\"/" withString:[NSString stringWithFormat:@"src=\"%@/", MONEY_AND_TECH_HOME_PAGE_URL]];
}


#pragma mark - time
-(void) extractTimeElementfromPostNumber:(int)postNumber intoPost:(RWPost*)post {
    NSArray *timeNodes = [self.pageParser searchWithXPathQuery:VIDEOS_PAGE_TIME_XPATH];
    TFHppleElement *timeElement = [timeNodes count] > postNumber ? timeNodes[postNumber] : nil;
    
    if (post != nil && timeElement != nil) {
        post.timeHTML = [self formattedTimeHTMLFromElement:timeElement];
    }
}

-(NSString*) formattedTimeHTMLFromElement:(TFHppleElement*)timeElement {
     return  [NSString stringWithFormat: @"<span style=\"display:inline-block; font-style:italic; float:left; padding-top:15px\">%@</span>", timeElement.raw];
}

-(NSString*) formattedArticleTextHTMLFromElement:(TFHppleElement*)articleTextElement {
    
    NSString* articleTextHTML = [NSString stringWithFormat: @"<div>%@</div>", articleTextElement.raw];
    articleTextHTML = [self resizeAssetsToFitFromHTML:articleTextHTML];
    return articleTextHTML;
}


#pragma mark - article
-(void) extractArticleElementfromPostNumber:(int)postNumber intoPost:(RWArticlePost*)articlePost {
    NSArray* articleNodes = [self.pageParser searchWithXPathQuery:ARTICLE_TEXT_XPATH];
    TFHppleElement *articleElement = [articleNodes count] > postNumber ? articleNodes[postNumber] : nil;
    
    if (articlePost != nil && articleElement != nil) {
        articlePost.articleHTML = [self formattedArticleTextHTMLFromElement:articleElement];
    }
}

#pragma mark - forum

-(NSString*) extractUnformatedForumHTML {
    NSArray *htmlNodes = [self.pageParser searchWithXPathQuery:FORUM_PAGE_XPATH];;
    TFHppleElement *htmlElement = htmlNodes[0];
    return htmlElement.raw;
}



@end
