//
//  RWVideosViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWHomeViewController.h"

#define HOME_URL [NSURL URLWithString:@"http://www.moneyandtech.com"]

@interface RWHomeViewController ()

@end

@implementation RWHomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor purpleColor];
    }
    return self;
}
- (void)viewDidLoad
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    
    
    NSURLRequest* homeRequest = [[NSURLRequest alloc] initWithURL: HOME_URL];
    [webView loadRequest:homeRequest];
    
    
    [self.view addSubview:webView];
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start Videos");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish Videos");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"failed Videos");
}

@end
