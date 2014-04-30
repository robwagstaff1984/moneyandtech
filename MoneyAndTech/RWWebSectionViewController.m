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
#import "RWExternalWebViewController.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "Reachability.h"

@interface RWWebSectionViewController ()
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL needsInfiniteScrollTurnedOff;
@property (nonatomic) int openRequestsCount;

@property (nonatomic) int currentContentHeight;
@property (nonatomic, strong) NSTimer *infinteScrollPaginationTimer;

@property (nonatomic, strong) UIView* noNetworkView;


@end

@implementation RWWebSectionViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.pageNumber = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [self setupWebView];
    [self setupActivityIndicator];
    [self testNetworkWithSuccessBlock:^(void){
         [self beginLoadingWebSections];
    }];



    [super viewDidLoad];
}

-(void) beginLoadingWebSections {
    if ([self shouldStripDownWebSection]) {
        [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:[self httpRequestOperationForWebSection]];
    } else {
        self.webView.hidden = NO;
        [self.webView loadRequest:[self urlRequestForFirstPage]];
    }
}

#pragma mark - setup

-(void) setupWebView {
    CGRect frameInsideTabBarController =  CGRectMake(0, 0, self.tabBarController.view.frame.size.width,
                                                     self.tabBarController.view.frame.size.height - self.tabBarController.tabBar.frame.size.height - NAV_BAR_HEIGHT);
    self.webView = [[UIWebView alloc] initWithFrame: frameInsideTabBarController];
    self.webView.hidden = YES;
    self.webView.delegate = self;
    [self.webView setBackgroundColor:MONEY_AND_TECH_GREY];
    
    if ([self shouldStripDownWebSection]) {
        __weak typeof(self) weakSelf = self;
        [self.webView.scrollView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadNextPage];
        } forPosition:SVInfiniteScrollingPositionBottom];
    }

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

    NSLog(@"Adding operation request for: %@", self.title);
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:[self urlRequestForFirstPage] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* strippedHTML = [NSString stringWithFormat:@"<html><body style=\"background-color:#F7F9F6\">%@</body></html>", [self strippedHTMLFromData:responseObject]];
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
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:[self urlRequestForNextPage] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self appendNextPageToDOM:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load section: %@  %@", self.title, error);
        [self.activityIndicator stopAnimating];
    }];
    [operation setQueuePriority:[self queuePriority]];
    
    [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:operation];
}

- (NSMutableURLRequest*) urlRequestForFirstPage {
    NSMutableURLRequest* webSectionRequest = [[NSMutableURLRequest alloc] initWithURL: [self urlForSection]];
    [webSectionRequest setValue:@"MyUserAgent (iPhone; iOS 7.0.2; gzip)" forHTTPHeaderField:@"User-Agent"];
    return webSectionRequest;
}


- (NSMutableURLRequest*) urlRequestForNextPage {
    NSLog(@"Adding next page operation request for: %@", self.title);
    self.pageNumber++;
    NSMutableURLRequest* webSectionRequest = [[NSMutableURLRequest alloc] initWithURL: [self urlForNextPage]];
    [webSectionRequest setValue:@"MyUserAgent (iPhone; iOS 7.0.2; gzip)" forHTTPHeaderField:@"User-Agent"];
    return webSectionRequest;
}

-(void) appendNextPageToDOM:(id)responseObject {
    NSString* strippedNextPageHTML = [self strippedHTMLFromData:responseObject];
    
    [self injectJavascript:[NSString stringWithFormat:@"var myDiv = document.createElement('p');\nmyDiv.innerHTML = '%@';\ndocument.body.appendChild(myDiv);", strippedNextPageHTML]];
    
    [self monitorForPaginationComplete];
}

-(void) monitorForPaginationComplete {
    self.currentContentHeight = self.webView.scrollView.contentSize.height;
    self.infinteScrollPaginationTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(checkIfPaginationIsComplete:) userInfo: nil repeats:YES];
}

-(void)checkIfPaginationIsComplete:(id)sender {
    if (self.currentContentHeight != self.webView.scrollView.contentSize.height) {
        NSLog(@"Pagination complete!");
        self.currentContentHeight = self.webView.scrollView.contentSize.height;
        [[self.webView.scrollView infiniteScrollingViewForPosition:SVInfiniteScrollingPositionBottom] stopAnimating];
        [self.infinteScrollPaginationTimer invalidate];
    }
}

-(NSString*) injectJavascript:(NSString*)javascript {
    NSString* result = [self.webView stringByEvaluatingJavaScriptFromString:javascript];
    return result;
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
}

-(BOOL) shouldStripDownWebSection {
    NSAssert(NO, @"This abstract method should be subclassed");
    return NO;
}

-(NSURL*) urlForNextPage {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
}

- (NSOperationQueuePriority)queuePriority {
    NSAssert(NO, @"This abstract method should be subclassed");
    return NSOperationQueuePriorityNormal;
}

-(NSString*) strippedHTMLFromData:(NSData*)htmlData {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
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
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.openRequestsCount--;
    if (self.openRequestsCount == 0) {
        NSLog(@"webViewDidFinishLoad All open requests finished");
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
-(void) testNetworkWithSuccessBlock:(void(^)(void))successBlock {
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(Reachability*reach) {
        if (self.webView.hidden) {
            successBlock();
        }
        [self.noNetworkView removeFromSuperview];
        NSLog(@"REACHABLE!");
    };
    
    reach.unreachableBlock = ^(Reachability*reach) {
        if (self.webView.hidden && self.noNetworkView == nil) {
            [self createNoNetworkView];
        }
        NSLog(@"UNREACHABLE!");
    };
    [reach startNotifier];
}

-(void) createNoNetworkView {
    self.noNetworkView = [[UIView alloc] initWithFrame:self.view.frame];
    self.noNetworkView.backgroundColor = [UIColor redColor];
    UIView *noNetworkLabel = [[UIView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAV_BAR_HEIGHT - 40)/2, SCREEN_WIDTH, 40)];
    noNetworkLabel.backgroundColor = [UIColor yellowColor];
//    noNetworkLabel.text = @"No internet connection";
//    noNetworkLabel.textColor = [UIColor greenColor];
    [self.view addSubview:self.noNetworkView];
    [self.view addSubview:noNetworkLabel];
}

@end
