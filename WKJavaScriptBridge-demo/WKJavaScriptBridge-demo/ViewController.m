//
//  ViewController.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "ViewController.h"
#import "TestWKWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSMutableURLRequest *reqeust = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [SHRMWebViewCookieMgr syncRequestCookie:reqeust];
//    [self.webView loadRequest:reqeust];
}

- (IBAction)goWKWebView:(id)sender {
    TestWKWebViewController *wkVC = [[TestWKWebViewController alloc] init];
    [self.navigationController pushViewController:wkVC animated:YES];
}

@end
