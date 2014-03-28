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
        self.view.backgroundColor = [UIColor greenColor];
        self.title = @"Articles";
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
  
    
    [self.view addSubview:self.webView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSURLRequest* videosRequest = [[NSURLRequest alloc] initWithURL: ARTICLES_URL];
    [self.webView loadRequest:videosRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start articles");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
//    NSString* videosPageStrippedJavascript = [RWRegexHTMLStripper videosPageStrippedJavascript];
//    
//    if (!self.isRestylingDone) {
//        self.isRestylingDone = YES;
//        [webView stringByEvaluatingJavaScriptFromString:videosPageStrippedJavascript];
//    }
//    
    NSLog(@"finish articles");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"failed articles");
}

@end
