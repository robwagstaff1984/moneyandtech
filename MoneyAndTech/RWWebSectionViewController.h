//
//  RWWebSectionViewController.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RWWebSectionProtocol <NSObject>

@required
-(NSURL*) urlForSection;
-(NSOperationQueuePriority)queuePriority;
@end

@interface RWWebSectionViewController : UIViewController <RWWebSectionProtocol, UIWebViewDelegate>

@end
