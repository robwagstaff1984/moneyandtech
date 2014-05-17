//
//  RWArticlesViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWArticlesViewController.h"

#define ARTICLES_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/articles", [RWConfiguration sharedConfiguration].homeURL]]
#define ARTICLES_NEXT_PAGE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/articles/page/%d/", [RWConfiguration sharedConfiguration].homeURL, self.pageNumber]]

@interface RWArticlesViewController ()
@property (nonatomic) UIWebView* webView;

@end

@implementation RWArticlesViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    return ARTICLES_URL;
}

-(BOOL) shouldStripDownWebSection {
    return [RWConfiguration sharedConfiguration].shouldReformatArticlesPage;
}

-(NSURL*) urlForNextPage {
    return ARTICLES_NEXT_PAGE_URL;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

-(NSString*) strippedHTMLFromData:(NSData*)htmlData {
    return [RWXPathStripper strippedHtmlFromArticlesHTML:htmlData];
}


- (NSString *)tabImageName
{
    return @"ArticlesIcon";
}

- (NSString *)tabTitle
{
    return @"Articles";
}


@end
