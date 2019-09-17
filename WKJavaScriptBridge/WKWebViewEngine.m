//
//  WKWebViewEngine.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKWebViewEngine.h"
#import "WKWebViewDelegate.h"
#import "WKCommandImpl.h"

@interface WKWebViewEngine ()<WKScriptMessageHandler, WKJavaScriptBridgeProtocol>

@property (nonatomic, strong) WKWebViewDelegate *WKWebViewDelegate;
@property (nonatomic, strong) WKWebPluginAnnotation *webPluginAnnotation;
@property (nonatomic, strong) WKWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, strong) NSMutableDictionary *pluginsMap;
@property (nonatomic, weak, readwrite) WKWebView *webView;
@property (nonatomic, weak, readwrite) NSObject <WKNavigationDelegate>*webViewDelegate;

@end

@implementation WKWebViewEngine

#pragma mark - public

+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView withDelegate:(NSObject <WKNavigationDelegate>*)webViewDelegate {
    return [self bridge:webView delegate:webViewDelegate];
}

#pragma mark - privite

+ (instancetype)bridge:(WKWebView *)webView delegate:(NSObject <WKNavigationDelegate>*)webViewDelegate {
    WKWebViewEngine *bridge = [[WKWebViewEngine alloc] init];
    if ([webView isKindOfClass:[WKWebView class]]) {
        bridge.webViewDelegate = webViewDelegate;
        bridge.webView = webView;
        
        [bridge setupInstance];
        [bridge configWKWebView:webView];
        [bridge setJavaScriptBridge:bridge];
        [bridge loadStartupPlugin];
        return bridge;
    }
    
    [NSException raise:@"BadWebViewType" format:@"Unknown web view type."];
    return nil;
}

- (void)configWKWebView:(WKWebView *)webView {
    webView.navigationDelegate = _WKWebViewDelegate;
    webView.configuration.userContentController = [[WKUserContentController alloc] init];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"WKJSBridge"];
}

- (void)setupInstance{
    _webViewhandleFactory = [[WKWebViewHandleFactory alloc] initWithWebViewEngine:self];
    _WKWebViewDelegate = [[WKWebViewDelegate alloc] initWithWebViewEngine:self];
    _webPluginAnnotation = [[WKWebPluginAnnotation alloc] initWithWebViewEngine:self];
    _pluginsMap = [NSMutableDictionary dictionary];
    _commandDelegate = [[WKCommandImpl alloc] initWithWebViewEngine:self];
    self.openWhiteList = YES;
}

- (void)loadStartupPlugin {
    [_webPluginAnnotation getAllRegisterPluginName];
}

- (void)registerPlugin:(WKBasePlugin *)plugin {
    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }
}

- (void)setJavaScriptBridge:(id<WKJavaScriptBridgeProtocol>)bridge {
    _bridge = bridge;
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSString class]]) {
        [_webViewhandleFactory handleMsgCommand:message.body];
    }
}

#pragma mark - WKJavaScriptBridgeProtocol

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id , NSError *))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(obj, error);
        }
    }];
}

- (void)setupPluginName:(NSString *)pluginName {
    [self.pluginsMap setValue:pluginName forKey:[pluginName lowercaseString]];
}

- (id)getCommandInstance:(NSString*)pluginName {
    NSString* className = [self.pluginsMap objectForKey:[pluginName lowercaseString]];
    if (className == nil && self.isOpenWhiteList) {
#ifdef DEBUG
        NSLog(@"(pluginName: (%@) does not register on the whitelist.", pluginName);
#endif
        return nil;
    }
    
    id obj = [[NSClassFromString(pluginName) alloc] initWithWebViewEngine:self];
    if (obj != nil) {
        [self registerPlugin:obj];
    }else {
#ifdef DEBUG
        NSLog(@"(pluginName: (%@) does not exist.", pluginName);
#endif
    }
    return obj;
}

#pragma mark - dealloc

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"WKJSBridge"];
}

@end
