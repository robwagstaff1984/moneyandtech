//
//  RWWebSectionViewController.h
//  MoneyAndTech
//
//  Created by Robert Wagstaff on 3/28/14.
//  Copyright (c) 2014 Robert Wagstaff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RWXPathStripper.h"
#import "RWConfiguration.h"

@protocol RWWebSectionProtocol <NSObject>

@required
-(NSURL*) urlForSection;
-(BOOL) shouldStripDownWebSection;
@optional
-(NSURL*) urlForNextPage;
-(NSOperationQueuePriority)queuePriority;
-(NSString*) strippedHTMLFromData:(NSData*)htmlData;
@end

@interface RWWebSectionViewController : UIViewController <RWWebSectionProtocol, UIWebViewDelegate>
@property (nonatomic) int pageNumber;

@end
