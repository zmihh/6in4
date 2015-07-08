//
//  NavigateViewController.h
//  ip6in4
//
//  Created by bupt419 on 14-11-17.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "Constants.h"

@interface ResourceViewController : UIViewController<UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property IBOutlet UIButton *button;
@property IBOutlet UILabel *label;
@property IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)onRefresh:(id)sender;

@end
