//
//  LoginViewController.h
//  ip6in4
//
//  Created by zhouhao on 15/9/29.
//  Copyright © 2015年 bupt419. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property IBOutlet UITextField *mEmailTF;

@property IBOutlet UITextField *mPasswdTF;
@property IBOutlet UITextField *mPasswdTF2;
@property IBOutlet UILabel *errorHint;
@property IBOutlet UIButton *mActionBtn;

//mode==1 for login, mode == 2 for register
-(void)setMode:(int)mode;

-(IBAction)gotonext:(id)sender;
-(IBAction)onGoOrNext:(id)sender;


-(IBAction)onActionClick:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
