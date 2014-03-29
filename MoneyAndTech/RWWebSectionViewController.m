//
//  RWWebSectionViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWWebSectionViewController.h"

@interface RWWebSectionViewController ()
@property (nonatomic, strong) UIWebView* webView;
@end

@implementation RWWebSectionViewController

- (void)viewDidLoad
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    
    NSURLRequest* webSectionRequest = [[NSURLRequest alloc] initWithURL: [self urlForCurrentPage]];
    [self.webView loadRequest:webSectionRequest];
    
    [self.view addSubview:self.webView];
    
    [super viewDidLoad];
}

-(NSURL*) urlForCurrentPage {
    NSLog(@"NOT SUBCLASSED");
    return nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"started: %@", self.title);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"failed to load webview for %@ %@", self.title, error);
    if([error code] == NSURLErrorCancelled)
        return;
}

@end
