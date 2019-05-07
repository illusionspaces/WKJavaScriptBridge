//
//  TestUIWebViewController.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "TestUIWebViewController.h"
#import <SHRMWebViewEngine.h>

@interface TestUIWebViewController ()
@property (nonatomic, strong) SHRMWebViewEngine* bridge;
@end

@implementation TestUIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    /***/
    _bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
    [_bridge setWebViewDelegate:self];
    /***/
    [self.view addSubview:webView];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"UIWebView webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"UIWebView webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"UIWebView webView:didFailLoadWithError:");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


@end
