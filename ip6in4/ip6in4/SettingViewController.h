//
//  SettingViewController.h
//  ip6in4
//
//  Created by bupt419 on 14-11-25.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMFeedback.h"
#import "UIView+Toast.h"
#import "ShareSDK/ShareSDK.h"
#import "Constants.h"
#import "LoginViewController.h"

@interface SettingViewController : UITableViewController<UIActionSheetDelegate, UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>

@property IBOutlet UIView* shareView;
@property IBOutlet UIView* importView;
@property IBOutlet UILabel* userName;
@property IBOutlet UILabel* userPlatform;
@property IBOutlet UILabel* versionTitle;
@property IBOutlet UILabel* versionDetail;



typedef void(^MGetUserInfoEventHandler) (BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> erro);
+ (void)getUserInfoWithType:(NSInteger)type result:(MGetUserInfoEventHandler)result;


//-(IBAction)installOpenVPN:(UITapGestureRecognizer*)sender;
-(IBAction)importConfig:(UITapGestureRecognizer*)sender;
-(IBAction)login:(UITapGestureRecognizer*)sender;
-(IBAction)openFeedback:(UITapGestureRecognizer*)sender;
//-(IBAction)copyVPNUserName:(UITapGestureRecognizer*)sender;
//-(IBAction)copyVPNPassword:(UITapGestureRecognizer*)sender;
-(IBAction)shareAPP:(UITapGestureRecognizer*)sender;

@end
