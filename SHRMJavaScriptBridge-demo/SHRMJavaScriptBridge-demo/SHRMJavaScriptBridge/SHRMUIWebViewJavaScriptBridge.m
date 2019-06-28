//
//  SHRMUIWebViewJavaScriptBridge.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/14.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMUIWebViewJavaScriptBridge.h"
#import "SHRMWebViewEngine.h"
#import "SHRMUIWebViewBridgeProtocol.h"

@interface SHRMUIWebViewJavaScriptBridge () <UIWebViewDelegate>
@property (nonatomic, strong) SHRMWebViewEngine *webViewEngine;
@property (nonatomic, strong) id <SHRMUIWebViewBridgeProtocol>UIWebViewBridge;
@end

@implementation SHRMUIWebViewJavaScriptBridge {
    __weak UIWebView *_webView;
}

+ (instancetype)bindBridgeWithWebView:(UIWebView *)webView {
    return [[self alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(UIWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
    }
    return self;
}

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext *)ctx {
    
}

#pragma mark - uiwebview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (webView != _webView) { return; }
    
    __strong WVJB_WEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [strongDelegate webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView != _webView) { return; }
    
    __strong WVJB_WEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [strongDelegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (webView != _webView) { return; }
    
    __strong WVJB_WEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [strongDelegate webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (webView != _webView) { return YES;}
    
    __strong WVJB_WEBVIEW_DELEGATE_TYPE* strongDelegate = _webViewDelegate;
    if (strongDelegate && [strongDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [strongDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }else {
        return YES;
    }
}

#pragma mark - setter&getter

- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    NSString *baseUIWebViewBridgeClass = @"SHRMUIBaseBridge";
    self.UIWebViewBridge = [[NSClassFromString(baseUIWebViewBridgeClass) alloc] init];
    self->_webView.delegate = self.UIWebViewBridge;
    [self.UIWebViewBridge setWebViewEngine:webViewEngine];
    self.UIWebViewBridge.UIWebViewDelegateCalss = self;
}

#pragma mark - SHRMJavaScriptBridgeProtocol

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id , NSError * ))completionHandler {
    NSString* ret = [(UIWebView*)_webView stringByEvaluatingJavaScriptFromString:javaScriptString];
    
    if (completionHandler) {
        completionHandler(ret, nil);
    }
}

- (void)reload {
    [_webView reload];
}

- (void)setOpenWhiteList:(BOOL)openWhiteList {
    self.webViewEngine.openWhiteList = openWhiteList;
}

@end
