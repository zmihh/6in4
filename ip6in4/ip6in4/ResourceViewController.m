//
//  NavigateViewController.m
//  ip6in4
//
//  Created by bupt419 on 14-11-17.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import "ResourceViewController.h"

@interface ResourceViewController (){
    NSString *mPageName;
}

@end

@implementation ResourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Do any additional setup after loading the view.
    
    mPageName = @"ResourcePage";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:APPIPv6ResUrl()]];
    [self.webView loadRequest:request];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:mPageName];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:mPageName];
}

-(void)toLoadingMode{
    self.webView.hidden = TRUE;
    [self.indicator startAnimating];
    self.label.hidden = FALSE;
    [self.label setText:@"Loading"];
}

-(void)toWebViewMode{
    self.webView.hidden = FALSE;
    [self.indicator stopAnimating];
    self.label.hidden = TRUE;
}

- (IBAction)onRefresh:(id)sender{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:APPIPv6ResUrl()]];
    [self.webView loadRequest:request];
}

-(void)selectRightAction:(id)sender
{
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:APPIPv6ResUrl()]];
    [self.webView loadRequest:request];
}

- (void )webViewDidStartLoad:(UIWebView  *)webView   //网页开始加载的时候调用
{
    [self toLoadingMode];
}
- (void )webViewDidFinishLoad:(UIWebView  *)webView  //网页加载完成的时候调用
{
    [self toWebViewMode];
}
- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error //网页加载错误的时候调用
{
    NSLog(@"didFailLoadWithError, error: %@", error);
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self.indicator stopAnimating];
    [self.label setText:error.localizedDescription];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL =[request URL];
    if (([[requestURL scheme] isEqualToString: @"http"]
         || [[requestURL scheme] isEqualToString: @"https"]
         || [[requestURL scheme] isEqualToString: @"mailto"])
         && (navigationType == UIWebViewNavigationTypeLinkClicked)){
        
        NSString *url = [requestURL absoluteString];
        if ([url isEqual:APPTutorialUrl()]) {
            [self performSegueWithIdentifier:@"res_to_tutorial" sender:self];
            return NO;
        }
        return ![[ UIApplication sharedApplication ] openURL:requestURL];
    }
    return YES;
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
