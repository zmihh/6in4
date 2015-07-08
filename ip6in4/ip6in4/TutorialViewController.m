//
//  TutorialViewController.m
//  ip6in4
//
//  Created by bupt419 on 14-12-2.
//  Copyright (c) 2014年 bupt419. All rights reserved.
//

#import "TutorialViewController.h"
#import "Constants.h"

@interface TutorialViewController (){
    NSString *mPageName;
}

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mPageName = @"TutorialViewController";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:APPTutorialUrl()]];
    [self.webView loadRequest:request];
}

-(void)selectRightAction:(id)sender
{
    NSString* title = NSLocalizedStringFromTable(@"choose_operation", @"TutorialViewController", nil);
    NSString* cancel = NSLocalizedStringFromTable(@"cancel", @"TutorialViewController", nil);
    NSString* open_in_safari = NSLocalizedStringFromTable(@"open_in_safari", @"TutorialViewController", nil);
    NSString* refresh = NSLocalizedStringFromTable(@"refresh", @"TutorialViewController", nil);
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self
                                              cancelButtonTitle:cancel destructiveButtonTitle:nil otherButtonTitles:open_in_safari, refresh, nil];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //open this page in safari
        [[ UIApplication sharedApplication ] openURL:[NSURL URLWithString:APPTutorialUrl()]];
    }else if (buttonIndex == 1){
        //refresh
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:APPTutorialUrl()]];
        [self.webView loadRequest:request];
    }
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
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        return ![[ UIApplication sharedApplication ] openURL:[request URL]];
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
