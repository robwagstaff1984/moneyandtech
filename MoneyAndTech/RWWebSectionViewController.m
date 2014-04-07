//
//  RWWebSectionViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWWebSectionViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "RWAFHTTPRequestOperationManager.h"
#import "RWXPathStripper.h"
#import "RWExternalWebViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"

@interface RWWebSectionViewController ()
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL needsInfiniteScrollTurnedOff;
@property (nonatomic) CGPoint offsetOfInfiniteScroll;
@property (nonatomic) int openRequestsCount;


//[alert addSubview: progress];
@end

@implementation RWWebSectionViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.pageNumber = 1;
        self.offsetOfInfiniteScroll = CGPointMake(0, -64);
    }
    return self;
}

- (void)viewDidLoad
{
    [self setupWebView];
    [self setupActivityIndicator];
    
    [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:[self httpRequestOperationForWebSection]];
    
    [super viewDidLoad];
}
#pragma mark - setup

-(void) setupWebView {
    CGRect frameInsideTabBarController =  CGRectMake(0, 0, self.tabBarController.view.frame.size.width,
                                                     self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height);
    self.webView = [[UIWebView alloc] initWithFrame: frameInsideTabBarController];
    self.webView.hidden = YES;
    self.webView.delegate = self;
    __weak typeof(self) weakSelf = self;
    [self.webView.scrollView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadNextPage];
    } forPosition:SVInfiniteScrollingPositionBottom];
    [self.view addSubview:self.webView];
    
}

-(void) setupActivityIndicator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] init];
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicator];
    self.activityIndicator.center = self.view.center;
}

#pragma mark - AFNetworking
-(AFHTTPRequestOperation*) httpRequestOperationForWebSection {
    NSMutableURLRequest* webSectionRequest = [[NSMutableURLRequest alloc] initWithURL: [self urlForSection]];
    [webSectionRequest setValue:@"MyUserAgent (iPhone; iOS 7.0.2; gzip)" forHTTPHeaderField:@"User-Agent"];
    
    NSLog(@"Adding operation request for: %@", self.title);
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:webSectionRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* strippedHTML = [RWXPathStripper strippedHtmlFromVideosHTML:responseObject];
        self.webView.hidden = NO;
        [self.webView loadHTMLString:strippedHTML baseURL:nil];
        [self.activityIndicator stopAnimating];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load section: %@  %@", self.title, error);
        [self.activityIndicator stopAnimating];
    }];
    [operation setQueuePriority:[self queuePriority]];
    [self.activityIndicator startAnimating];
    return operation;
}

-(void) loadNextPage {
    self.pageNumber++;
    NSMutableURLRequest* nextPageRequest = [[NSMutableURLRequest alloc] initWithURL: [self urlForNextPage]];

    [nextPageRequest setValue:@"MyUserAgent (iPhone; iOS 7.0.2; gzip)" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"Adding next page operation request for: %@", self.title);
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:nextPageRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* originalHTML = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        NSString* strippedNextPageHTML = [RWXPathStripper strippedHtmlFromVideosHTML:responseObject];
        NSString* newHTML =  [RWXPathStripper addNextPage:strippedNextPageHTML toOriginalHTML:originalHTML];
        
        self.offsetOfInfiniteScroll = self.webView.scrollView.contentOffset;
        [self.webView loadHTMLString:newHTML baseURL:[NSURL URLWithString:nil]];
        self.needsInfiniteScrollTurnedOff = YES;
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load section: %@  %@", self.title, error);
        [self.activityIndicator stopAnimating];
    }];
    [operation setQueuePriority:[self queuePriority]];
    
     [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:operation];
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
}

-(NSURL*) urlForNextPage {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
}

- (NSOperationQueuePriority)queuePriority {
    NSAssert(NO, @"This abstract method should be subclassed");
    return NSOperationQueuePriorityNormal;
}

#pragma mark - UIWebviewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        [self pushExternalWebViewWithRequest:request];
        return NO;
    }

    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
//        NSLog(@"webViewDidStartLoad");
    self.openRequestsCount++;
    if(self.webView.scrollView.contentOffset.y == -64) {
        NSLog(@"adjusting offset");
        [self.webView.scrollView setContentOffset:self.offsetOfInfiniteScroll animated:NO];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.openRequestsCount--;
    NSLog(@"webViewDidFinishLoad %d", self.openRequestsCount);
    
    if(self.webView.scrollView.contentOffset.y == -64) {
        NSLog(@"adjusting offset");
        [self.webView.scrollView setContentOffset:self.offsetOfInfiniteScroll animated:NO];
    }
    
    if(self.needsInfiniteScrollTurnedOff && self.openRequestsCount == 0) {
        NSLog(@"Turning off infinite scroll");
        self.needsInfiniteScrollTurnedOff = NO;
        
        [[self.webView.scrollView infiniteScrollingViewForPosition:SVInfiniteScrollingPositionBottom] stopAnimating];
    }
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.openRequestsCount--;
    NSLog(@"didFailLoadWithError");
}

#pragma mark - external link clicks
-(void) pushExternalWebViewWithRequest:(NSURLRequest *)request {
    NSLog(@"clicked external link");
    UINavigationController* externalWebViewNavigationController = [[UINavigationController alloc] init];
    RWExternalWebViewController* externalWebViewController = [[RWExternalWebViewController alloc] initWithURLRequest:request];
    externalWebViewNavigationController.viewControllers = @[externalWebViewController];
    [self.navigationController pushViewController:externalWebViewController animated:YES];
}


@end
