//
//  Constants.m
//  ip6in4
//
//  Created by bupt419 on 14-11-17.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import "Constants.h"

NSString * const IPv6Res_URL_Key = @"url_ipv6_resource";
NSString * const IPv6Res_URL_Default = @"http://www.6able.com/res/ios";

NSString* APPIPv6ResUrl(){
    NSString *url = [MobClick getConfigParams:IPv6Res_URL_Key];
    if (url == nil) {
        url = IPv6Res_URL_Default;
    }
    return url;
}

NSString * const AccountCheckUrlKey = @"url_account_check";
NSString * const AccountCheckUrlDefault = @"http://www.6able.com/account/checkiOS";

NSString* APPAccountCheckUrl(){
    NSString *url = [MobClick getConfigParams:AccountCheckUrlKey];
    if (url == nil) {
        url = AccountCheckUrlDefault;
    }
    return url;
}

NSString * const TutorialUrlKey = @"url_tutorial";
NSString * const TutorialUrlDefault = @"http://6able.com/res/tutorialiOS";

NSString* APPTutorialUrl(){
    NSString *url = [MobClick getConfigParams:TutorialUrlKey];
    if (url == nil) {
        url = TutorialUrlDefault;
    }
    return url;
}

NSString * const ShareTextKey= @"share_text";
NSString * const ShareTextDefault = @"我正在使用6in4来访问IPv6资源，太好用啦，快来下载吧：http://www.6able.com";

NSString* APPShareText(){
    NSString *text = [MobClick getConfigParams:ShareTextKey];
    if (text == nil) {
        text = ShareTextDefault;
    }
    return text;
}