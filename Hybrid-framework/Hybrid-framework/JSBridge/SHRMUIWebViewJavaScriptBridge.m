//
//  SHRMUIWebViewJavaScriptBridge.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/14.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMUIWebViewJavaScriptBridge.h"
#import "SHRMWebViewHandleFactory.h"

@implementation SHRMUIWebViewJavaScriptBridge {
    __weak UIWebView *_webView;
    SHRMWebViewHandleFactory *_webViewHandleFactory;
}

@synthesize rootViewController = _rootViewController;

+ (instancetype)bindBridgeWithWebView:(UIWebView *)webView; {
    return [[self alloc] initWithWebView:webView];
}

- (instancetype)initWithWebView:(UIWebView *)webView {
    if (self = [super init]) {
        _webView = webView;
        _webView.delegate = self;
        _webViewHandleFactory = [[SHRMWebViewHandleFactory alloc] init];
        _webViewHandleFactory.webViewBridge = self;
    }
    return self;
}

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
    if ([webViewDelegate isKindOfClass:[UIViewController class]]) {
        self.rootViewController = (UIViewController *)webViewDelegate;
    }
}

#pragma mark - SHRMWebViewProtocol

- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId {
    NSString *jsStr = [NSString stringWithFormat:@"fetchComplete('(%@)','%@')",callbackId,result];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

#pragma mark - uiwebview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
