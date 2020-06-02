//
//  TestWKwebViewController.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "TestWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKJavaScriptBridge.h"

@interface TestWKWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKJavaScriptBridge *bridge;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKProcessPool *processPool;
@property (nonatomic, assign, getter=loadFinished) BOOL isLoadFinished;
@end

@implementation TestWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isLoadFinished = NO;
    /*
      由于WKWebView在请求过程中用户可能退出界面销毁对象，当请求回调时由于接收处理对象不存在，造成Bad Access crash，所以可将WKProcessPool设为单例
     */
    static WKProcessPool *_sharedWKProcessPoolInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWKProcessPoolInstance = [[WKProcessPool alloc] init];
    });
    self.processPool = _sharedWKProcessPoolInstance;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    configuration.processPool = self.processPool;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView = webView;
    webView.navigationDelegate = self;
    [self addUserScript:webView];
    /***/
    self.bridge = [WKJavaScriptBridge bindBridgeWithWebView:webView];
    /***/
    [self.view addSubview:webView];
    
    /*
     //解决首个请求cookie带不上的问题可以使用如下方式
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
     [WKWebViewCookieMgr syncRequestCookie:request];
     [webView loadRequest:request];
     */
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    if (@available(iOS 9.0, *)) {
        [webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /*
      解决调用系统相机等产生白屏，导致内存紧张，WebContent Process 被系统挂起，此时不会执行webViewWebContentProcessDidTerminate:函数
     */
    if (!self.webView.title) {
        [self.webView reload];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isLoadFinished = YES;
}

#pragma mark - privite

/**
 通过·document.cookie·设置cookie解决后续页面(同域)Ajax、iframe请求的cookie问题

 @param webView wkwebview
 */
- (void)addUserScript:(WKWebView *)webView {
//    NSString *js = [WKWebViewCookieMgr clientCookieScripts];
//    if (!js) return;
//    WKUserScript *jsscript = [[WKUserScript alloc]initWithSource:js
//                                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart
//                                                forMainFrameOnly:NO];
//    [webView.configuration.userContentController addUserScript:jsscript];
}

#pragma mark - WKNavigationDelegate

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    /*
      解决内存过大引起的白屏问题
     */
    [webView reload];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    /*
     //如果是302重定向请求，此处拦截带上cookie重新request
    NSMutableURLRequest *newRequest = [WKWebViewCookieMgr newRequest:navigationAction.request];
    [webView loadRequest:newRequest];
     */
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    //解决window.alert() 时 completionHandler 没有被调用导致崩溃问题
    if (!self.isLoadFinished) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    if (self)
        [self presentViewController:alertController animated:YES completion:^{}];
    else
        completionHandler();
}


@end
