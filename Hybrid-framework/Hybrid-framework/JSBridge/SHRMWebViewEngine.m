//
//  SHRMWebViewEngine.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebViewEngine.h"
#import "SHRMWebViewDelegate.h"
#import "SHRMWebViewHandleFactory.h"

@interface SHRMWebViewEngine ()
@property (nonatomic, strong) SHRMWebViewDelegate *webViewDelegate;
@property (nonatomic, strong) SHRMWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, strong) SHRMWebPluginAnnotation *webPluginAnnotation;
@property (nonatomic, strong) NSMutableDictionary *pluginObject;
@end

@implementation SHRMWebViewEngine

- (instancetype)init {
    if (self = [super init]) {
        _webViewhandleFactory = [[SHRMWebViewHandleFactory alloc] initWithWebViewEngine:self];
        _webViewDelegate = [[SHRMWebViewDelegate alloc] initWithWebViewEngine:self];
        _webPluginAnnotation = [[SHRMWebPluginAnnotation alloc] initWithWebViewEngine:self];
        _pluginObject = [NSMutableDictionary dictionary];
        [self loadStartupPlugin];
    }
    return self;
}

#pragma mark - bridge

- (void)bindBridgeWithWebView:(WKWebView *)webView {
    self.webView = webView;
    if (![_delegate conformsToProtocol:@protocol(WKUIDelegate)]) {
        self.webView.UIDelegate = _webViewDelegate;
    }
    if (![_delegate conformsToProtocol:@protocol(WKNavigationDelegate)]) {
        self.webView.navigationDelegate = _webViewDelegate;
    }
    webView.configuration.userContentController = [[WKUserContentController alloc] init];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"SHRMWKJSBridge"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSArray class]]) {
        [_webViewhandleFactory handleMsgCommand:message.body];
    }
}

#pragma mark - SHRMWebViewProtocol

- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId {
    NSString *jsStr = [NSString stringWithFormat:@"fetchComplete('(%@)','%@')",callbackId,result];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (void)registerStartupPluginName:(NSString *)pluginName onload:(NSNumber *)onload {
    if ([onload boolValue]) {
        [self getCommandInstance:pluginName];
    }
}

#pragma mark - plugin handle

- (void)loadStartupPlugin {
    [_webPluginAnnotation getAllRegisterPluginName];
}

- (id)getCommandInstance:(NSString*)pluginName {
    id obj = [_pluginObject objectForKey:[pluginName lowercaseString]];
    if (!obj) {
        obj = [[NSClassFromString(pluginName) alloc] init];
        if (obj != nil) {
            [_pluginObject setObject:obj forKey:[pluginName lowercaseString]];
        }else {
            NSLog(@"(pluginName: (%@) does not exist.", pluginName);
        }
    }
    return obj;
}

#pragma mark - dealloc

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SHRMWKJSBridge"];
}

@end
