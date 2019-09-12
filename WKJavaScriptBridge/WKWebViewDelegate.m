//
//  WKWebViewDelegate.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/6.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKWebViewDelegate.h"
#import "WKWebViewEngine.h"

#define WVJB_WKWEBVIEW_DELEGATE_TYPE NSObject<WKNavigationDelegate>

@implementation WKWebViewDelegate {
    __weak WKWebViewEngine *_webViewEngine;
}

- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine {
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
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewEngine.webViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [strongDelegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [strongDelegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [strongDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [strongDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [strongDelegate webView:webView didCommitNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [strongDelegate webView:webView didFinishNavigation:navigation];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailNavigation:withError:)]) {
        [strongDelegate webView:webView didFailNavigation:navigation withError:error];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [strongDelegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    
    __strong WVJB_WKWEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewEngine.webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
        if (@available(iOS 9.0, *)) {
            [strongDelegate webViewWebContentProcessDidTerminate:webView];
        } else {
            
        }
    }
}

@end
