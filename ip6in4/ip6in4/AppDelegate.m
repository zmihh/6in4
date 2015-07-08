//
//  AppDelegate.m
//  ip6in4
//
//  Created by bupt419 on 14-11-17.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import "AppDelegate.h"
#import "UMFeedback.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/QQApiInterface.h"
#import "ShareSDK/Extend/QQConnectSDK/TencentOpenAPI.framework/Headers/TencentOAuth.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MobClick startWithAppkey:@"5469aea6fd98c540350013b9" reportPolicy:BATCH channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick updateOnlineConfig];
    [MobClick checkUpdate];
    
    [UMFeedback setAppkey:@"5469aea6fd98c540350013b9"];
    
    
    [ShareSDK registerApp:@"471c66665604"];
    [ShareSDK connectSinaWeiboWithAppKey:@"2728604013"
                               appSecret:@"aff3382960ce99eeff9cb3adb53bf858"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"
                             weiboSDKCls:[WeiboSDK class]];
    
    [ShareSDK connectDoubanWithAppKey:@"0cfbe76c9488761626f3b645bd996242"
                            appSecret:@"78fb90af95bde6ff"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    
    [ShareSDK connectQZoneWithAppKey:@"1103295018"
                           appSecret:@"Ijm83Xs48ALOXfcj"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:@"1103295018"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //wechat
    [ShareSDK connectWeChatWithAppId:@"wx5534ae6215e74e32"   //微信APPID
                           appSecret:@"e0ac81d1390a0e8b9657ac5020ced2a4"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    //连接邮件
    [ShareSDK connectMail];
    
    [ShareSDK ssoEnabled:NO];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
