//
//  RegisterController.m
//  ip6in4
//
//  Created by zhouhao on 15/7/6.
//  Copyright (c) 2015年 bupt419. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController()
    
@property(nonatomic,strong)UITextField *email;
@property(nonatomic,strong)UITextField *pwd;

@end

@implementation RegisterController

-(void)viewDidLoad{
    UIBarButtonItem *navFinish=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClick)];
     self.navigationItem.rightBarButtonItem=navFinish;
    [self.navigationItem setTitle:@"注册"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self registView];
}

-(void)registView{
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
    [emailLabel setText:@"电子邮箱"];
     emailLabel.highlighted=YES;
    [emailLabel setHighlightedTextColor:[UIColor blackColor]];
    [emailLabel setFont:font];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    [emailLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:emailLabel];
    
    _email=[[UITextField alloc]initWithFrame:CGRectMake(padx, 10, 200, 40)] ;
    [_email setBackgroundColor:[UIColor clearColor]];
    [_email setKeyboardType:UIKeyboardTypeEmailAddress];
    [_email setTextColor:[UIColor grayColor]];
    [_email setTag:101];
    [_email setReturnKeyType:UIReturnKeyNext];
    [_email setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_email setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_email setFont:[UIFont systemFontOfSize:17]];
    [_email setPlaceholder:@"devdiy@example.com"];
   // [_email setText:@""];
    [_email setHighlighted:YES];
    [view1 addSubview:_email];
    
    
    //密码
    UILabel *pwdLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 53, 45, 40)];
    [pwdLabel setText:@"密码"];
    pwdLabel.highlighted=YES;
    [pwdLabel setHighlightedTextColor:[UIColor blackColor]];
    [pwdLabel setFont:font];
    [pwdLabel setBackgroundColor:[UIColor clearColor]];
    [pwdLabel setTextColor:[UIColor blackColor]];
    [view1 addSubview:pwdLabel];
    
     _pwd=[[UITextField alloc]initWithFrame:CGRectMake(padx, 53, 200, 40)] ;
    [_pwd setBackgroundColor:[UIColor clearColor]];
    [_pwd setKeyboardType:UIKeyboardTypeDefault];
    [_pwd setTextColor:[UIColor grayColor]];
    [_pwd setTag:102];
    [_pwd setReturnKeyType:UIReturnKeyDone];
    [_pwd setSecureTextEntry:YES];
    [_pwd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_pwd setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_pwd setFont:font];
    //[_pwd setText:@""];
    [_pwd setHighlighted:YES];
    [view1 addSubview:_pwd];

    
}

-(void)buttonClick{
    if ((_email.text.length!=0)&&(_pwd.text.length!=0) ) {
    
        if(![self NSStringIsValidEmail:_email.text]){
       // NSString *title=@"InValid email";
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"invalid email" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            alertView.alertViewStyle=UIAlertActionStyleDefault;
            [alertView show];
        }
        else{
       // NSDictionary* default=[[NSUserDefaults standardUserDefaults]dictionaryRepresentation];
        //NSLog(@"%@",default);
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults] ;
            NSString* userName=self.email.text;
            NSString* passWord=self.pwd.text;
            [defaults setObject:userName forKey:@"username"];
            [defaults setObject:passWord forKey:@"passward"];
            NSLog(@"save");
            [self.navigationController popViewControllerAnimated:YES];
        
       // NSLog(@"Defaults: %@", defaults);

        
        }
    }
    else{
        //NSLog(@"%ld",_email.text.length);
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"input could not be empty" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        alertView.alertViewStyle=UIAlertActionStyleDefault;
        [alertView show];
    }
    
}
-(BOOL) NSStringIsValidEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}


@end
