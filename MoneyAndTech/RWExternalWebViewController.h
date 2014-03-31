//
//  RWExternalWebViewController.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/31/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RWExternalWebViewController : UIViewController <UIWebViewDelegate>

- (id)initWithURLRequest:(NSURLRequest *)request;

@end
