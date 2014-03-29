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

@interface RWWebSectionViewController ()
@property (nonatomic, strong) UIWebView* webView;
@end

@implementation RWWebSectionViewController

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    
    [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:[self httpRequestOperationForWebSection]];
    
    [super viewDidLoad];
}

-(AFHTTPRequestOperation*) httpRequestOperationForWebSection {
    NSURLRequest* webSectionRequest = [[NSURLRequest alloc] initWithURL: [self urlForCurrentPage]];
    NSLog(@"Adding operation request for: %@", self.title);
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:webSectionRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* response =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Successfully loaded %@", self.title);
//        NSLog(@"Response: %@", response);
        [self.webView loadHTMLString:response baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load section: %@  %@", self.title, error);
    }];
    return operation;
}

#pragma mark - abstract methods
-(NSURL*) urlForCurrentPage {
    NSAssert(NO, @"This method should be subclassed");
    return nil;
}

@end
