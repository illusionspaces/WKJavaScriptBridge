//
//  SHRMUIWebViewJavaScriptBridge.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/14.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMUIWebViewJavaScriptBridge.h"
#import "SHRMWebViewEngine.h"
#import "UIWebView+TS_JavaScriptContext.h"

@interface SHRMUIWebViewJavaScriptBridge () <TSWebViewDelegate>
@property (nonatomic, strong) SHRMWebViewEngine *webViewEngine;
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
        _webView.delegate = self;
    }
    return self;
}

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
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

#pragma mark - TSWebViewDelegate

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*)ctx {
    __weak SHRMUIWebViewJavaScriptBridge *weakSelf = self;
    ctx[@"postUIWebViewParamer"] = ^(NSArray *paramer){
        dispatch_async( dispatch_get_main_queue(), ^{
            [weakSelf.webViewEngine.webViewhandleFactory handleMsgCommand:paramer];
        });
    };
}

#pragma mark - setter&getter

- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    _webViewEngine = webViewEngine;
}

#pragma mark - SHRMJavaScriptBridgeProtocol

- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId {
    NSString *jsStr = [NSString stringWithFormat:@"fetchComplete('(%@)','%@')",callbackId,result];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
}

@end
