//
//  RWWebSectionViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWWebSectionViewController.h"

@interface RWWebSectionViewController ()

@end

@implementation RWWebSectionViewController

- (void)viewDidLoad
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    
    NSURLRequest* webSectionRequest = [[NSURLRequest alloc] initWithURL: [self urlForCurrentPage]];
    [webView loadRequest:webSectionRequest];
    
    [self.view addSubview:webView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
}

@end
