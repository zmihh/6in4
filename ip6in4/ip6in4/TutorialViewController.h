//
//  TutorialViewController.h
//  ip6in4
//
//  Created by bupt419 on 14-12-2.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property IBOutlet UIButton *button;
@property IBOutlet UILabel *label;
@property IBOutlet UIActivityIndicatorView *indicator;

@end
