//
//  SHRMJSCoreBrdige.m
//  SHRMJavaScriptBridge-demo
//
//  Created by Kevin on 2019/6/3.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMJSCoreBrdige.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "SHRMWebViewEngine.h"
#import <WebKit/WebKit.h>

@interface SHRMJSCoreBrdige ()<TSWebViewDelegate>
@property (nonatomic, strong) SHRMWebViewEngine *webViewEngine;
@end

@implementation SHRMJSCoreBrdige

@synthesize UIWebViewDelegateCalss;

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.UIWebViewDelegateCalss webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.UIWebViewDelegateCalss webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.UIWebViewDelegateCalss webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.UIWebViewDelegateCalss webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }else {
        return YES;
    }
}

#pragma mark - TSWebViewDelegate

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*)ctx {
    ctx[@"postUIWebViewParamer"] = ^(NSArray *paramer){
        dispatch_async( dispatch_get_main_queue(), ^{
            if (self.webViewEngine) {
                [self.webViewEngine.webViewhandleFactory handleMsgCommand:paramer];
            }
        });
    };
}

#pragma mark - SHRMUIWebViewBridgeProtocol

- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    _webViewEngine = webViewEngine;
}

- (void)dealloc {
    self.webViewEngine = nil;
}

@end
