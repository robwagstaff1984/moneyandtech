//
//  RWExternalWebViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/31/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWExternalWebViewController.h"

@interface RWExternalWebViewController ()
@property(nonatomic,strong) UIWebView* webView;
@property(nonatomic,strong) NSURLRequest* request;
@end

@implementation RWExternalWebViewController

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.title = @"MONEY & TECH";
        self.request = request;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startSpinner];
    [self setupWebView];
}

#pragma mark - setup
-(void) setupWebView {
    self.webView = [[UIWebView alloc] initWithFrame: self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"shouldStartLoad");
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
    [self stopSpinner];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"didFailLoadWithError");
}


@end
