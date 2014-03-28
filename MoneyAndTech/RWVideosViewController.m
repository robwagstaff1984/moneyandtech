//
//  RWVideosViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWVideosViewController.h"
#import "RWRegexHTMLStripper.h"

#define VIDEOS_URL [NSURL URLWithString:@"http://www.moneyandtech.com/videos"]

#define JAVASCRIPT_RESTYLE_VIDEOS_PAGE @"document.getElementsByTagName('body')[0].style['visibility']='hidden'; document.getElementsByTagName('article')[0].style['visibility']='visible';"

@interface RWVideosViewController ()
@property (nonatomic) BOOL isRestylingDone;

@end

@implementation RWVideosViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor yellowColor];
        self.title = @"Money and Tech";
    }
    return self;
}
- (void)viewDidLoad
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    NSURLRequest* videosRequest = [[NSURLRequest alloc] initWithURL: VIDEOS_URL];
    [webView loadRequest:videosRequest];

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

    NSString* videosPageStrippedJavascript = [RWRegexHTMLStripper videosPageStrippedJavascript];
    
    if (!self.isRestylingDone) {
        self.isRestylingDone = YES;
        [webView stringByEvaluatingJavaScriptFromString:videosPageStrippedJavascript];
        NSLog(@"stripping down HTML!");
    }
    
    NSLog(@"finish Videos");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"failed Videos");
}

@end
