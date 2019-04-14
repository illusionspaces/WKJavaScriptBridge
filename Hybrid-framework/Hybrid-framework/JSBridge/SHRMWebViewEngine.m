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
#import "SHRMUIWebViewJavaScriptBridge.h"

@interface SHRMWebViewEngine ()
@property (nonatomic, strong) SHRMWebViewDelegate *WKWebViewDelegate;
@property (nonatomic, strong) SHRMWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, strong) SHRMWebPluginAnnotation *webPluginAnnotation;
@property (nonatomic, strong) NSMutableDictionary *pluginObject;
@property (nonatomic, weak, readwrite) WKWebView *webView;
@end

@implementation SHRMWebViewEngine

@synthesize rootViewController = _rootViewController;

#pragma mark - bridge

+ (instancetype)bindBridgeWithWebView:(id)webView {
    return [self bridge:webView];
}

+ (instancetype)bridge:(id)webView {
    if ([webView isKindOfClass:[WKWebView class]]) {
        SHRMWebViewEngine *bridge = [[SHRMWebViewEngine alloc] init];
        [bridge configWKWebView:webView];
        [bridge addUserScript:webView];
        [bridge setupInstance];
        [bridge loadStartupPlugin];
        return bridge;
    }
    
    if ([webView isKindOfClass:[UIWebView class]]) {
       return (SHRMWebViewEngine *)[SHRMUIWebViewJavaScriptBridge bindBridgeWithWebView:webView];
    }
    [NSException raise:@"BadWebViewType" format:@"Unknown web view type."];
    return nil;
}

- (void)configWKWebView:(WKWebView *)webView {
    _webView = webView;
    _webView.navigationDelegate = _WKWebViewDelegate;
    _webView.configuration.userContentController = [[WKUserContentController alloc] init];
    [_webView.configuration.userContentController addScriptMessageHandler:self name:@"SHRMWKJSBridge"];
}

- (void)addUserScript:(WKWebView *)webView {
    NSString *js = [SHRMWebViewCookieMgr clientCookieScripts];
    if (!js) return;
    WKUserScript *jsscript = [[WKUserScript alloc]initWithSource:js
                                                   injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                forMainFrameOnly:NO];
    [webView.configuration.userContentController addUserScript:jsscript];
}

- (void)setupInstance{
    _webViewhandleFactory = [[SHRMWebViewHandleFactory alloc] initWithWebViewEngine:self];
    _webViewhandleFactory.webViewBridge = self;
    _WKWebViewDelegate = [[SHRMWebViewDelegate alloc] initWithWebViewEngine:self];
    _webPluginAnnotation = [[SHRMWebPluginAnnotation alloc] initWithWebViewEngine:self];
    _pluginObject = [NSMutableDictionary dictionary];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSArray class]]) {
        [_webViewhandleFactory handleMsgCommand:message.body];
    }
}

#pragma mark - SHRMWebViewProtocol

- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId {
    NSString *jsStr = [NSString stringWithFormat:@"fetchComplete('(%@)','%@')",callbackId,result];
    [self.webView evaluateJavaScript:jsStr completionHandler:nil];
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
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

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
    if ([webViewDelegate isKindOfClass:[UIViewController class]]) {
        self.rootViewController = (UIViewController *)webViewDelegate;
    }
}

- (void)registerStartupPluginName:(NSString *)pluginName onload:(NSNumber *)onload {
    if ([onload boolValue]) {
        [self getCommandInstance:pluginName];
    }
}

#pragma mark - dealloc

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SHRMWKJSBridge"];
}

@end
