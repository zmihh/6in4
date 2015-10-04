//
//  SettingViewController.m
//  ip6in4
//
//  Created by bupt419 on 14-11-25.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "RegisterController.h"
#import "LoginController.h"



#define ALERT_TAG_FOR_LOGIN 34
#define ALERT_TAG_FOR_UPDATE    28
#define ALERT_TAG_FOR_IMPORT    10

@interface SettingViewController (){
    //ShareType loginType;
   // MBProgressHUD *hud;
    MBProgressHUD *hud;
    NSString* updatePath;
    UIDocumentInteractionController *dic;
}
@end


@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MobClick checkUpdateWithDelegate:self selector:@selector(updateVersionInfo:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self updateLoginInfo];
}


-(IBAction)login:(UITapGestureRecognizer*)sender{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *platform = [defaults objectForKey:@"platform"];
    if (platform != nil
            &&
            (
                ([platform isEqualToString:PLATFORM_QQ] && [ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
                || ([platform isEqualToString:PLATFORM_SINA_WEIBO] && [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
                || [platform isEqualToString:PLATFORM_Email]
            )
        ) {
        //already login
        NSString* logoutTitle = NSLocalizedStringFromTable(@"logout_title", @"SettingViewController", nil);
        NSString* cancelLogout = NSLocalizedStringFromTable(@"cancel_logout", @"SettingViewController", nil);
        NSString* confirmLogout = NSLocalizedStringFromTable(@"confirmLogout", @"SettingViewController", nil);
        NSString* logoutMessage = NSLocalizedStringFromTable(@"logout_message", @"SettingViewController", nil);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:logoutTitle message:logoutMessage delegate:self cancelButtonTitle:cancelLogout otherButtonTitles:confirmLogout,nil];
        alert.alertViewStyle=UIAlertViewStyleDefault;
        [alert setTag:ALERT_TAG_FOR_LOGIN];
        [alert show];
    }else{
        //not login
        NSString *title = NSLocalizedStringFromTable(@"platform_title", @"SettingViewController", nil);
        NSString *cancel = NSLocalizedStringFromTable(@"cancel_btn", @"SettingViewController", nil);
        NSString *qq = NSLocalizedStringFromTable(@"qq", @"SettingViewController", nil);
        NSString *sinaweibo = NSLocalizedStringFromTable(@"sinaweibo", @"SettingViewController", nil);
        NSString *email=NSLocalizedStringFromTable(@"Email",@"SettingViewController",nil);
        NSString *emailRegister=NSLocalizedStringFromTable(@"注册账号",@"SettingViewController",nil);
        UIActionSheet* mySheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:cancel
                                  destructiveButtonTitle:emailRegister
                                  otherButtonTitles:qq, sinaweibo,email, nil];
        [mySheet showInView:self.view];
    }
}

-(void)updateLoginInfo{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *platform = [defaults objectForKey:@"platform"];
    if (platform != nil
        && (([platform isEqualToString:PLATFORM_QQ] && [ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) || ([platform isEqualToString:PLATFORM_SINA_WEIBO] && [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
            || [platform isEqualToString:PLATFORM_Email])) {
        //already login
        NSString* nickname = [defaults objectForKey:@"nickname"];
        [self.userName setText:nickname];
        if ([platform isEqualToString:PLATFORM_SINA_WEIBO]) {
            NSString* platform = NSLocalizedStringFromTable(@"platform_from_sina_weibo", @"SettingViewController", nil);
            [self.userPlatform setText:platform];
        }
        else if([platform isEqualToString:PLATFORM_Email]){
            NSString* platform = NSLocalizedStringFromTable(@"platform_from_email", @"SettingViewController", nil);
            [self.userPlatform setText:platform];
        }
        else{
            NSString* platform = NSLocalizedStringFromTable(@"platform_from_qq", @"SettingViewController", nil);
            [self.userPlatform setText:platform];
        }
        
    }else{
        //not login
        NSString* notLoginTitle = NSLocalizedStringFromTable(@"not_login_title", @"SettingViewController", nil);
        NSString* notLoginHint = NSLocalizedStringFromTable(@"not_login_hint", @"SettingViewController", nil);
        [self.userName setText:notLoginTitle];
        [self.userPlatform setText:notLoginHint];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    if (tag == ALERT_TAG_FOR_LOGIN) {
        if (buttonIndex == 1) {
            //confirm logout
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString* platform = [defaults objectForKey:@"platform"];
            ShareType type = [platform isEqualToString:PLATFORM_QQ]?ShareTypeQQSpace:ShareTypeSinaWeibo;
            [ShareSDK cancelAuthWithType:type];
            [defaults setObject:nil forKey:@"platform"];
            [defaults synchronize];
            [self updateLoginInfo];
        }
    }else if(tag == ALERT_TAG_FOR_UPDATE){
        if (buttonIndex == 1) {
            //goto appstore for update
            NSString *iTunesLink = updatePath;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }else if (tag == ALERT_TAG_FOR_IMPORT){
        [self importConfigFileAlertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        //register
        //RegisterController *reController=[[RegisterController alloc]init];
        //[self.navigationController pushViewController:reController animated:YES];
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [vc setMode:2];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (buttonIndex == 1) {
        //qq login
        [self dologin:ShareTypeQQSpace];
    }else if (buttonIndex == 2){
        //sina weibo login
        [self dologin:ShareTypeSinaWeibo];
    }else if(buttonIndex == 3){
       // [self ]
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [vc setMode:1];
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        //LoginController *loginController=[[LoginController alloc]init];
        //[self.navigationController pushViewController:loginController animated:YES];
        
    }
    
}


-(void)dologin:(ShareType)type{
    [ShareSDK
     getUserInfoWithType:type //平台类型
     authOptions:nil //授权选项
     result:^(BOOL result, id userInfo, id error) { //返回回调
         NSString *login_success = NSLocalizedStringFromTable(@"login_success", @"SettingViewController", nil);
         NSString *login_failed = NSLocalizedStringFromTable(@"login_failed", @"SettingViewController", nil);
         if (result){
             hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
             NSString* validate_hint = NSLocalizedStringFromTable(@"validate_account", @"SettingViewController", nil);
             hud.labelText = validate_hint;
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
   
                 NSDictionary *resultDic = [self validateAccount:userInfo accountType:type];
                 if (resultDic == nil) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self updateLoginInfo];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [self showToast:login_failed];
                     });
                     return;
                 }
                 //NSLog(@"dic:%@:",resultDic);
                 NSString *userId = [resultDic objectForKey:@"id"];
                 NSString *password = [resultDic objectForKey:@"password"];
                 NSString *vpn_ip = [resultDic objectForKey:@"ip"];
                 NSString *vpn_port = [resultDic objectForKey:@"port"];
                 //NSLog(@"id=%@,pwd=%@,ip=%@,port=%@", userId, password, vpn_ip, vpn_port);
                 
                 NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                 [defaults setObject:type==ShareTypeSinaWeibo?PLATFORM_SINA_WEIBO:PLATFORM_QQ forKey:@"platform"];
                 [defaults setObject:[userInfo uid] forKey:@"uid"];
                 [defaults setObject:vpn_ip forKey:@"vpn_ip"];
                 [defaults setObject:vpn_port forKey:@"vpn_port"];
                 [defaults setObject:userId forKey:@"username"];
                 [defaults setObject:password forKey:@"password"];
                 [defaults setObject:[userInfo nickname] forKey:@"nickname"];
                 [defaults synchronize];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self updateLoginInfo];
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [self showToast:login_success];
                 });
             });
         } else {
             //NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
             [self showToast:login_failed];
         }
    }];
}

-(NSDictionary*)validateAccount:(id)userInfo accountType:(ShareType)type{
    NSString* uid = nil;
    if (type == ShareTypeSinaWeibo) {
        //sina weibo
        uid = [NSString stringWithFormat:@"sina_weibo_%@", [userInfo uid]];
    }else if (type == ShareTypeQQSpace){
        //qq
        uid = [NSString stringWithFormat:@"qq_%@", [userInfo uid]];
    }
    NSURL *url = [NSURL URLWithString:APPAccountCheckUrl()];
    NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [urlRequest setHTTPMethod:@"POST"];
    //{"id":"__id__","name":"__name__"}
    NSString* param = [NSString stringWithFormat:@"data={\"id\":\"%@\",\"name\":\"%@\"}", uid, [userInfo nickname]];
    [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (error == nil){
        // 处理数据
        /*
        {
         errno = 0;
         id = "sina_weibo_2074513234";
         ip = "114.247.165.5";
         name = "\U98d8\U98d8\U9999\U98d8\U98d8";
         password = 55a2e58f2c8e34301b8a7a477a9c2e99;
         port = 1194;
        }
        */
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return resultDic;
    }else{
        NSLog(@"error code is %ld, description:%@", (long)error.code, error.description);
    }
    return nil;
}

-(void)showToast:(NSString*)content{
    int barHeight = self.tabBarController.tabBar.bounds.size.height;
    UIView *view = self.navigationController.view;
    [view makeToast:content
           duration:2.0
           position:[NSValue valueWithCGPoint:CGPointMake(view.bounds.size.width/2,view.bounds.size.height - barHeight - 30)] ];
}

-(IBAction)openFeedback:(UITapGestureRecognizer*)sender{
    UIViewController *controller = [UMFeedback feedbackViewController];
    controller.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:controller animated:YES];
}

/*
-(IBAction)checkUpdate:(id)sender{
    [MobClick checkUpdateWithDelegate:self selector:@selector(appUpdate:)];
}
 */

/*
- (void)appUpdate:(NSDictionary *)appInfo{
    [self updateVersionInfo:appInfo];
    NSString* title = NSLocalizedStringFromTable(@"update_title", @"SettingViewController", nil);
    NSString* message = [appInfo objectForKey:@"update_log"];//NSLocalizedStringFromTable(@"update_description", @"SettingViewController", nil);
    NSString* cancel = NSLocalizedStringFromTable(@"cancel_update", @"SettingViewController", nil);
    NSString* update = NSLocalizedStringFromTable(@"update", @"SettingViewController", nil);
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:update,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert setTag:ALERT_TAG_FOR_UPDATE];
    updatePath = [appInfo objectForKey:@"path"];
    [alert show];
}
 */

-(void)updateVersionInfo:(NSDictionary*)appInfo{
    NSLog(@"appInfo=%@", appInfo);
    BOOL update = [[appInfo objectForKey:@"update"] boolValue];
    if (update) {
        NSString* title = NSLocalizedStringFromTable(@"find_new_version", @"SettingViewController", nil);
        [self.versionTitle setText:title];
        NSString* detail = NSLocalizedStringFromTable(@"new_ve%@rsion%@_detail", @"SettingViewController", nil);
        NSString* curtVersion = [appInfo objectForKey:@"current_version"];
        NSString* newVersion = [appInfo objectForKey:@"version"];
        NSString* version_detail = [NSString stringWithFormat:detail, curtVersion, newVersion];
        [self.versionDetail setText:version_detail];
    }else{
        NSString* title = NSLocalizedStringFromTable(@"check_new_version", @"SettingViewController", nil);
        [self.versionTitle setText:title];
        NSString* detail = NSLocalizedStringFromTable(@"current_version:%@", @"SettingViewController", nil);
        NSString* curtVersion = [appInfo objectForKey:@"current_version"];
        [self.versionDetail setText:[NSString stringWithFormat:detail, curtVersion]];
    }
}


-(IBAction)shareAPP:(UITapGestureRecognizer*)sender{
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"icon152" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:APPShareText()
                                       defaultContent:APPShareText()
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"6in4"
                                                  url:@"http://www.6able.com"
                                          description:APPShareText()
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:self.shareView arrowDirect:UIPopoverArrowDirectionLeft];
    //然后将container对象传入showShareActionSheet的第一个参数中，如：
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container shareList:nil content:publishContent
                     statusBarTips:YES authOptions:nil shareOptions:nil
        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
            if (state == SSResponseStateSuccess){
                NSLog(@"分享成功");
                [self showToast:NSLocalizedStringFromTable(@"share_success", @"SettingViewController", nil)];
            }else if (state == SSResponseStateFail){
                NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                [self showToast:NSLocalizedStringFromTable(@"share_failed", @"SettingViewController", nil)];
            }else if (state == SSResponseStateCancel){
                //[self showToast:NSLocalizedStringFromTable(@"share_canceled", @"SettingViewController", nil)];
            }
    }];
}

-(void)importConfigFileAlertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //NSLog(@"button id = %ld", buttonIndex);
    if (buttonIndex == 0) {
        //cancel
    }else if (buttonIndex == 1){
        //goto appstore to install openvpn
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/openvpn-connect/id590379981?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }else if (buttonIndex == 2){
        //do config file import
        [self doImport];
    }
}

-(IBAction)importConfig:(UITapGestureRecognizer*)sender{
    
    NSString* title = NSLocalizedStringFromTable(@"import_config_title", @"SettingViewController", nil);
    NSString* message = NSLocalizedStringFromTable(@"import_config_message", @"SettingViewController", nil);
    NSString* cancel = NSLocalizedStringFromTable(@"cancel_import", @"SettingViewController", nil);
    NSString *to_appstore = NSLocalizedStringFromTable(@"goto_appstore", @"SettingViewController", nil);
    NSString *do_import = NSLocalizedStringFromTable(@"do_import", @"SettingViewController", nil);
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:to_appstore, do_import,nil];
    alert.alertViewStyle=UIAlertViewStyleDefault;
    [alert setTag:ALERT_TAG_FOR_IMPORT];
    [alert show];
    
    return;
    
    
    
}

-(void)doImport{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSLog(@"default = %@",defaults);
    NSString *platform = [defaults objectForKey:@"platform"];
    if (platform != nil
        && (([platform isEqualToString:PLATFORM_QQ] && [ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) || ([platform isEqualToString:PLATFORM_SINA_WEIBO] && [ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
            || [platform isEqualToString:PLATFORM_Email])) {
        
        //delete old ovpn file
        NSString *config_file = @"6in4.ovpn";
        [self deleteFileWithName:config_file];
        //create new file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"6in4" ofType:@"ovpn"];
            
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"before content = %@", content);
        content = [content stringByReplacingOccurrencesOfString:@"{server_ip}" withString:[defaults objectForKey:@"vpn_ip"]];
        content = [content stringByReplacingOccurrencesOfString:@"{server_port}" withString:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"vpn_port"]]];
        content = [content stringByReplacingOccurrencesOfString:@"{user_name}" withString:[defaults objectForKey:@"username"]];
        content = [content stringByReplacingOccurrencesOfString:@"{user_password}" withString:[defaults objectForKey:@"password"]];
        //NSLog(@"content is %@",content);
        
        //save new file to local storage
        filePath = [self createFileWithName:config_file content:content];
        if (dic == nil) {
            dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
            dic.delegate = self;
        }
        [dic presentOpenInMenuFromRect:CGRectMake(0, 0, 250, 40) inView:self.importView animated:TRUE];
    }else{
        //not login
        NSString *hint = NSLocalizedStringFromTable(@"not_login_hint", @"SettingViewController", nil);
        [self showToast:hint];
    }
}

- (NSString*)createFileWithName:(NSString *)fileName content:(NSString*)content
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // 1st, This funcion could allow you to create a file with initial contents.
    // 2nd, You could specify the attributes of values for the owner, group, and permissions.
    // Here we use nil, which means we use default values for these attibutes.
    // 3rd, it will return YES if NSFileManager create it successfully or it exists already.
    if ([manager createFileAtPath:filePath contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil]) {
        NSLog(@"Created the File Successfully.");
        return filePath;
    } else {
        NSLog(@"Failed to Create the File");
    }
    return nil;
}

- (void)deleteFileWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    // Need to check if the to be deleted file exists.
    if ([manager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        // This function also returnsYES if the item was removed successfully or if path was nil.
        // Returns NO if an error occurred.
        [manager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
    }
}

- (void)readFileWithName:(NSString *)fileName
{
    // Fetch directory path of document for local application.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // Have the absolute path of file named fileName by joining the document path with fileName, separated by path separator.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // NSFileManager is the manager organize all the files on device.
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        // Start to Read.
        NSError *error = nil;
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:&error];
        NSLog(@"File Content: %@", content);
        
        if (error) {
            NSLog(@"There is an Error: %@", error);
        }
    } else {
        NSLog(@"File %@ doesn't exists", fileName);
    }
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
