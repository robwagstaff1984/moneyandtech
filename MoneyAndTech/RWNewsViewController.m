//
//  RWNewsViewController.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/19/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "RWNewsViewController.h"
#define NEWS_URL [NSURL URLWithString:@"http://www.moneyandtech.com/news"]

@interface RWNewsViewController ()
@property (nonatomic) UIWebView* webView;
@end

@implementation RWNewsViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
        self.title = @"News";
    }
    return self;
}

- (void)viewDidLoad
{
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
  
    [self.view addSubview:self.webView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSURLRequest* videosRequest = [[NSURLRequest alloc] initWithURL: NEWS_URL];
    [self.webView loadRequest:videosRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
