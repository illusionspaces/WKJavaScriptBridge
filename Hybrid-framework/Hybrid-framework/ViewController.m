//
//  ViewController.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "SHRMWebViewEngine.h"
@interface ViewController ()
@property (nonatomic, strong) SHRMWebViewEngine* bridge;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    /***/
    _bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
    [_bridge setWebViewDelegate:self];
    /***/
    
    [self.view addSubview:webView];
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    if (@available(iOS 9.0, *)) {
        [webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    } else {
        // Fallback on earlier versions
    }
    
//    NSMutableURLRequest *reqeust = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
//    [SHRMWebViewCookieMgr syncRequestCookie:reqeust];
//    [self.webView loadRequest:reqeust];
}


@end
