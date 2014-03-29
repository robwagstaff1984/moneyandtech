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
#import "MBProgressHUD.h"

@interface RWWebSectionViewController ()
@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) MBProgressHUD* hud;
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
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RWAFHTTPRequestOperationManager sharedRequestOperationManager].operationQueue addOperation:[self httpRequestOperationForWebSection]];
    
    [super viewDidLoad];
}

-(AFHTTPRequestOperation*) httpRequestOperationForWebSection {
    NSMutableURLRequest* webSectionRequest = [[NSMutableURLRequest alloc] initWithURL: [self urlForSection]];
    [webSectionRequest setValue:@"MyUserAgent (iPhone; iOS 7.0.2; gzip)" forHTTPHeaderField:@"User-Agent"];
    
    NSLog(@"Adding operation request for: %@", self.title);
    
    AFHTTPRequestOperation* operation = [[RWAFHTTPRequestOperationManager sharedRequestOperationManager] HTTPRequestOperationWithRequest:webSectionRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* response =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Successfully loaded %@", self.title);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSLog(@"Response: %@", response);
        [self.webView loadHTMLString:response baseURL:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load section: %@  %@", self.title, error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [operation setQueuePriority:[self queuePriority]];
    return operation;
}

#pragma mark - RWWebSectionProtocol
-(NSURL*) urlForSection {
    NSAssert(NO, @"This abstract method should be subclassed");
    return nil;
}

- (NSOperationQueuePriority)queuePriority {
    NSAssert(NO, @"This abstract method should be subclassed");
    return NSOperationQueuePriorityNormal;
}

@end
