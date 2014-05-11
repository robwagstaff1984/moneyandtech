//
//  UIViewController+ActivitySpinner.m
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 5/11/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import "UIViewController+ActivitySpinner.h"
#import <objc/runtime.h>

@interface UIViewController()
@property (nonatomic, strong) UIActivityIndicatorView* loadingActivityIndicator;
@end

@implementation UIViewController (ActivitySpinner)

static char defaultHashKey ;

-(void) startSpinner {
    
    [self setupLoadingActivityIndicator];
    [self.loadingActivityIndicator startAnimating];
}

-(void) setupLoadingActivityIndicator {
    if (self.loadingActivityIndicator == nil) {
        [self createLoadingActivityIndicator];
    }
}
-(void) createLoadingActivityIndicator {
    self.loadingActivityIndicator = [[UIActivityIndicatorView alloc] init];
    self.loadingActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.loadingActivityIndicator];
    self.loadingActivityIndicator.center = self.view.center;
}

-(void) stopSpinner {
    [self.loadingActivityIndicator stopAnimating];
}

- (void)setLoadingActivityIndicator:(UIActivityIndicatorView*)loadingActivityIndicator
{
    objc_setAssociatedObject(self, &defaultHashKey, loadingActivityIndicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC) ;
}

-(UIActivityIndicatorView*) loadingActivityIndicator {
    return objc_getAssociatedObject(self, &defaultHashKey) ;
}

@end


