//
//  RWArticlesViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWArticlesViewController.h"

#define ARTICLES_URL [NSURL URLWithString:@"http://www.moneyandtech.com/articles"]

@interface RWArticlesViewController ()
@property (nonatomic) BOOL isRestylingDone;
@property (nonatomic) UIWebView* webView;

@end

@implementation RWArticlesViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Articles";
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

-(NSURL*) urlForCurrentPage {
    return ARTICLES_URL;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish articles");
}


@end
