//
//  LoginViewController.m
//  ip6in4
//
//  Created by zhouhao on 15/9/29.
//  Copyright © 2015年 bupt419. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"

@interface LoginViewController (){
    
    MBProgressHUD *hud;
    int mCurtMode;
}

@end

@implementation LoginViewController

-(void)setMode:(int)mode{
    if (mode == 1 || mode == 2) {
        mCurtMode = mode;
    }else{
        mCurtMode = 1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    self.errorHint.hidden = YES;
    //if([self lastEmail] != NULL){
    //    [self.mEmailTF setText:[self lastEmail]];
    //}
    if (mCurtMode == 1) {
        //login
        self.mPasswdTF.returnKeyType = UIReturnKeyGo;
        self.mPasswdTF2.hidden = YES;
        [self.mActionBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.navigationItem setTitle:@"登录"];
        
    }else{
        self.mPasswdTF.returnKeyType = UIReturnKeyNext;
        self.mPasswdTF2.hidden = NO;
        [self.mActionBtn setTitle:@"注册" forState:UIControlStateNormal];
        [self.navigationItem setTitle:@"注册"];
    }
    [self.mEmailTF becomeFirstResponder];
    
}

-(IBAction)onGoOrNext:(id)sender{
    if (mCurtMode == 1) {
        [self onActionClick:sender];
    }else if (mCurtMode == 2){
        [self.mPasswdTF2 becomeFirstResponder];
    }
}

-(IBAction)onActionClick:(id)sender{
    [self hideKeyboard];
    NSString* email = self.mEmailTF.text;
    if (![self isValidateEmail:email]) {
        
        [self showError:@"邮箱格式有误"];
        //self.mEmailHint.hidden = NO;
        return;
    }
    NSString *passwd = self.mPasswdTF.text;
    if (passwd == NULL || passwd.length < 6) {
        [self showError:@"密码长度不能小于6位"];
        return;
    }
    if (mCurtMode == 2) {
        NSString *passwd2 = self.mPasswdTF2.text;
        if (passwd2 == NULL || ![passwd isEqualToString:passwd2] ) {
            [self showError:@"密码不相同"];
            return;
        }
    }
    [self doAction:email withPassword:passwd forAction:mCurtMode];
}


-(void)doAction:(NSString*)email withPassword:(NSString*)password forAction:(int)action{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = mCurtMode == 1?@"正在登录" : @"正在注册";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        NSDictionary *resultDic = nil;
        if (mCurtMode == 1) {
            resultDic = [self loginAccount:email withPassword:password];
        }else if (mCurtMode == 2){
            resultDic = [self registerAccount:email withPassword:password];
        }
        
        NSLog(@"err = %i", [[resultDic objectForKey:@"err"] intValue]);
        int err = -1;
        if (resultDic != nil && [resultDic objectForKey:@"err"] != nil) {
            err = [[resultDic objectForKey:@"err"] intValue];
        }
        if (resultDic == nil || err != 0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self updateLoginInfo];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //[self showToast:login_failed];
                [self showToast:(mCurtMode == 1 ? @"登录失败，请稍后再试" : @"注册失败，请稍后再试")];
                if (mCurtMode == 2) {
                    
                    if (err == 3) {
                        [self showError:@"该邮箱已注册"];
                    }
                }
                if (mCurtMode == 1) {
                    if (err == 3) {
                        [self showError:@"密码错误"];
                    }else if (err == 2){
                        [self showError:@"账号不存在"];
                    }
                }
            });
            return;
        }
        NSLog(@"dic:%@:",resultDic);
        NSString *userId = [resultDic objectForKey:@"id"];
        NSString *password = [resultDic objectForKey:@"password"];
        NSString *vpn_ip = [resultDic objectForKey:@"ip"];
        NSString *vpn_port = [resultDic objectForKey:@"port"];
        NSLog(@"id=%@,pwd=%@,ip=%@,port=%@", userId, password, vpn_ip, vpn_port);
        
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        [defaults setObject:PLATFORM_Email forKey:@"platform"];
        //[defaults setObject:[userInfo uid] forKey:@"uid"];
        [defaults setObject:email forKey:@"uid"];
        [defaults setObject:vpn_ip forKey:@"vpn_ip"];
        [defaults setObject:vpn_port forKey:@"vpn_port"];
        [defaults setObject:userId forKey:@"username"];
        [defaults setObject:password forKey:@"password"];
        //[defaults setObject:[userInfo nickname] forKey:@"nickname"];
        [defaults setObject:email forKey:@"nickname"];
        [defaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self updateLoginInfo];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showToast:mCurtMode == 1 ? @"登录成功" : @"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        });
    });
}


-(NSDictionary*)registerAccount:(NSString*)email withPassword:(NSString*)passwd{
    //32位小写的字符串
    NSString *md5Passwd = [[self md5:passwd] lowercaseString];
    NSLog(@"pass = %@, md5 = %@", passwd, md5Passwd);
    
    NSURL *url = [NSURL URLWithString:APPAccountRegisterUrl()];
    NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [urlRequest setHTTPMethod:@"POST"];
    //{"op":"register","email":"__email__","passwd":"__md5_passwd__"}
    NSString* param = [NSString stringWithFormat:@"{\"op\":\"register\",\"email\":\"%@\",\"passwd\":\"%@\"}", email, md5Passwd];
    [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
    
    //NSData *data = [@"{\"errno\": 0,\"id\": \"sina_weibo_2074513234\",\"ip\": \"114.247.165.5\",\"name\": \"test\",\"password\": \"55a2e58f2c8e34301b8a7a477a9c2e99\",\"port\": 1194}" dataUsingEncoding:NSUTF8StringEncoding];
    if (error == nil){
        // 处理数据
        /*
         {
         errno:0,
         id:"sina_weibo_2074513234",
         ip:"114.247.165.5",
         name:"\U98d8\U98d8\U9999\U98d8\U98d8",
         password:55a2e58f2c8e34301b8a7a477a9c2e99,
         port:1194,
         }
         */
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"result =  %@", resultDic);
        return resultDic;
    }else{
        NSLog(@"error code is %ld, description:%@", (long)error.code, error.description);
    }
    return nil;
}

-(NSDictionary*)loginAccount:(NSString*)email withPassword:(NSString*)passwd{
    //32位小写的字符串
    NSString *md5Passwd = [[self md5:passwd] lowercaseString];
    NSLog(@"pass = %@, md5 = %@", passwd, md5Passwd);
    
    NSURL *url = [NSURL URLWithString:APPAccountLoginUrl()];
    NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [urlRequest setHTTPMethod:@"POST"];
    //{"op":"login","email":"__email__","passwd":"__md5_passwd__"}
    NSString* param = [NSString stringWithFormat:@"{\"op\":\"login\",\"email\":\"%@\",\"passwd\":\"%@\"}", email, md5Passwd];
    [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    //NSData *data = [@"{\"errno\": 0,\"id\": \"sina_weibo_2074513234\",\"ip\": \"114.247.165.5\",\"name\": \"test\",\"password\": \"55a2e58f2c8e34301b8a7a477a9c2e99\",\"port\": 1194}" dataUsingEncoding:NSUTF8StringEncoding];
    if (error == nil){
        // 处理数据
        /*
         {
         errno:0,
         id:"sina_weibo_2074513234",
         ip:"114.247.165.5",
         name:"\U98d8\U98d8\U9999\U98d8\U98d8",
         password:55a2e58f2c8e34301b8a7a477a9c2e99,
         port:1194,
         }
         */
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"result =  %@", resultDic);
        return resultDic;
    }else{
        NSLog(@"error code is %ld, description:%@", (long)error.code, error.description);
    }
    return nil;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

-(void)hideError{
    self.errorHint.hidden = YES;
}

-(void)showError:(NSString*)error{
    if (error != NULL) {
        self.errorHint.text = error;
        self.errorHint.hidden = NO;
    }else{
        [self hideError];
    }
}

-(IBAction)gotonext:(id)sender{
    //[sender resignFirstResponder];
    [self.mPasswdTF becomeFirstResponder];
}

-(IBAction)gotoPasswd2:(id)sender{
    [self.mPasswdTF2 becomeFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [self hideKeyboard];
}

-(void)hideKeyboard{
    [self.mEmailTF resignFirstResponder];
    [self.mPasswdTF resignFirstResponder];
    if (mCurtMode == 2) {
        [self.mPasswdTF2 resignFirstResponder];
    }
}

- (void)keyboardShow:(NSNotification *)notif {
    //self.mEmailHint.hidden = YES;
    [self hideError];
}

- (void)keyboardHide:(NSNotification *)notif {
//    NSString* email = self.mEmailTF.text;
//    if (![self isValidateEmail:email]) {
//        self.mEmailHint.hidden = NO;
//    }
}

-(void)showToast:(NSString*)content{
    int barHeight = self.tabBarController.tabBar.bounds.size.height;
    UIView *view = self.navigationController.view;
    [view makeToast:content
           duration:2.0
           position:[NSValue valueWithCGPoint:CGPointMake(view.bounds.size.width/2,view.bounds.size.height - barHeight - 30)] ];
}

- (BOOL)isValidateEmail:(NSString *)Email{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
