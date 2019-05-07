//
//  TestWKwebViewController.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "TestWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "SHRMWebViewEngine.h"

@interface TestWKWebViewController ()<WKNavigationDelegate>
@property (nonatomic, strong) SHRMWebViewEngine* bridge;
@end

@implementation TestWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    webView.navigationDelegate = self;
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
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
