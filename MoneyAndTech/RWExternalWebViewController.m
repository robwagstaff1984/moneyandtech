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
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end

@implementation RWExternalWebViewController

- (id)initWithURLRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        self.title = @"Money And Tech";
        self.request = request;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupWebView];
    [self setupActivityIndicator];
}

#pragma mark - setup
-(void) setupWebView {
    self.webView = [[UIWebView alloc] initWithFrame: self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView loadRequest:self.request];
}

-(void) setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
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
    [self.activityIndicator stopAnimating];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
}


@end
