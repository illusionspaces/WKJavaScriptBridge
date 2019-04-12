//
//  SHRMWebViewDelegate.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/6.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebViewDelegate.h"
#import "SHRMWebViewEngine.h"

@implementation SHRMWebViewDelegate {
    __weak SHRMWebViewEngine *_webViewEngine;
    UIProgressView *_progressView;
}

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
    }
    return self;
}

#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。
// WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
// 但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //302 cookie注入
    [SHRMWebViewCookieMgr resetCookie];
    
    if (_webViewEngine.webViewDelegate && [_webViewEngine.webViewDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewEngine.webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

@end
