//
//  LoginController.m
//  ip6in4
//
//  Created by zhouhao on 15/7/6.
//  Copyright (c) 2015年 bupt419. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *navFinish=[[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
    self.navigationItem.rightBarButtonItem=navFinish;
    [self.navigationItem setTitle:@"登录"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self loginView];
}

-(void)loginView{
    CGFloat padx=95.0f;
    CGRect RegisterFrame=CGRectMake(10, 88, 300, 125);
    UIFont *font=[UIFont boldSystemFontOfSize:16];
    //邮箱和密码背景颜色设置
    UIView* view1=[[UIView alloc]initWithFrame:RegisterFrame];
    view1.layer.cornerRadius=8.0f;
    view1.layer.borderWidth=1.0f;
    view1.layer.borderColor=[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f].CGColor;
    [view1 setBackgroundColor:[UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1.0f]];
    [self.view addSubview:view1];
    //邮箱与密码中间分界线
    UIView *lineOne=[[UIView alloc]initWithFrame:CGRectMake(0, 50, 300, 1)];
    [lineOne setBackgroundColor:[UIColor colorWithRed:209.0f/255.0f green:209.0f/255.0f blue:209.0f/255.0f alpha:1.0f]];
    [view1 addSubview:lineOne];
    //邮箱
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 280, 40)];
    [emailLabel setText:@"邮箱"];
    emailLabel.highlighted=YES;
    [emailLabel setHighlightedTextColor:[UIColor blackColor]];
    [emailLabel setFont:font];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:emailLabel];
    
    UITextField *email=[[UITextField alloc]initWithFrame:CGRectMake(60, 10, 200, 40)] ;
    //[email setBackgroundColor:[UIColor clearColor]];
    [email setBackgroundColor:[UIColor redColor]];
    [email setKeyboardType:UIKeyboardTypeEmailAddress];
    [email setTextColor:[UIColor grayColor]];
    [email setTag:101];
    [email setReturnKeyType:UIReturnKeyNext];
    [email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [email setFont:[UIFont systemFontOfSize:17]];
    [email setPlaceholder:@"devdiy@example.com"];
    [email setText:@""];
    [email setHighlighted:YES];
    [view1 addSubview:email];
    
    
    //密码
    UILabel *pwdLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 53, 45, 40)];
    [pwdLabel setText:@"密码"];
    pwdLabel.highlighted=YES;
    [pwdLabel setHighlightedTextColor:[UIColor blackColor]];
    [pwdLabel setFont:font];
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:pwdLabel];
    
    UITextField *pwd=[[UITextField alloc]initWithFrame:CGRectMake(padx, 53, 200, 40)] ;
    [pwd setBackgroundColor:[UIColor clearColor]];
    [pwd setKeyboardType:UIKeyboardTypeDefault];
    [pwd setTextColor:[UIColor grayColor]];
    [pwd setTag:102];
    [pwd setReturnKeyType:UIReturnKeyDone];
    [pwd setSecureTextEntry:YES];
    [pwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [pwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    [pwd setFont:font];
    [pwd setText:@""];
    [pwd setHighlighted:YES];
    [view1 addSubview:pwd];
    
    
    
}

-(void)buttonClick{
    NSLog(@"save");
    [self accountAuthentication];
    
}

-(void)accountAuthentication{
    //用户名不存在
    //用户名与密码不匹配
    //匹配
    if (self) {
        [self dismissViewControllerAnimated:true completion:nil];
    }
    
}

@end
