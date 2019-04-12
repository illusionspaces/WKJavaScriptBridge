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
@property (nonatomic, strong) SHRMWebViewDelegate *WKWebViewDelegate;
@property (nonatomic, strong) SHRMWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, strong) SHRMWebPluginAnnotation *webPluginAnnotation;
@property (nonatomic, strong) NSMutableDictionary *pluginObject;
@property (nonatomic, weak, readwrite) WKWebView *webView;

@end

@implementation SHRMWebViewEngine

@synthesize rootViewController = _rootViewController;

- (instancetype)init {
    if (self = [super init]) {
        _webViewhandleFactory = [[SHRMWebViewHandleFactory alloc] initWithWebViewEngine:self];
        _WKWebViewDelegate = [[SHRMWebViewDelegate alloc] initWithWebViewEngine:self];
        _webPluginAnnotation = [[SHRMWebPluginAnnotation alloc] initWithWebViewEngine:self];
        _pluginObject = [NSMutableDictionary dictionary];
        [self loadStartupPlugin];
    }
    return self;
}

#pragma mark - bridge

+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView {
    return [self bridge:webView];
}

+ (instancetype)bridge:(id)webView {
    if ([webView isKindOfClass:[WKWebView class]]) {
        SHRMWebViewEngine *bridge = [[SHRMWebViewEngine alloc] init];
        [bridge setupInstance:webView];
        [bridge addUserScript:webView];
        return bridge;
    }
    [NSException raise:@"BadWebViewType" format:@"Unknown web view type."];
    return nil;
}

- (void)setupInstance:(WKWebView *)webView {
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

#pragma mark - WKScriptMessageHandler

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

#pragma setter & getter

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
    if ([webViewDelegate isKindOfClass:[UIViewController class]]) {
        self.rootViewController = (UIViewController *)webViewDelegate;
    }
}

#pragma mark - dealloc

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SHRMWKJSBridge"];
}

@end
