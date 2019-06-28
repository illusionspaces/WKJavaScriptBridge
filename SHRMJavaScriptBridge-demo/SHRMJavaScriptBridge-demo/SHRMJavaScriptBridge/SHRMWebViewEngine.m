//
//  SHRMWebViewEngine.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebViewEngine.h"
#import "SHRMWebViewDelegate.h"
#import "SHRMUIWebViewJavaScriptBridge.h"
#import "SHRMCommandImpl.h"

@interface SHRMWebViewEngine ()

@property (nonatomic, strong) SHRMWebViewDelegate *WKWebViewDelegate;
@property (nonatomic, strong) SHRMWebPluginAnnotation *webPluginAnnotation;
@property (nonatomic, strong) NSMutableDictionary *pluginsMap;
@property (nonatomic, weak, readwrite) UIView *webView;

@end

@implementation SHRMWebViewEngine

@synthesize openWhiteList = _openWhiteList;

#pragma mark - public

+ (instancetype)bindBridgeWithWebView:(id)webView {
    return [self bridge:webView];
}

- (void)setupPluginName:(NSString *)pluginName {
    [self.pluginsMap setValue:pluginName forKey:[pluginName lowercaseString]];
}

- (id)getCommandInstance:(NSString*)pluginName {
    NSString* className = [self.pluginsMap objectForKey:[pluginName lowercaseString]];
    if (className == nil && self.isOpenWhiteList) {
        NSLog(@"(pluginName: (%@) does not register on the whitelist.", pluginName);
        return nil;
    }
    
    id obj = [[NSClassFromString(pluginName) alloc] initWithWebViewEngine:self];
    if (obj != nil) {
        [self registerPlugin:obj];
    }else {
        NSLog(@"(pluginName: (%@) does not exist.", pluginName);
    }
    return obj;
}

- (void)setWebViewDelegate:(NSObject<UIWebViewDelegate> *)webViewDelegate {
    _webViewDelegate = webViewDelegate;
}

#pragma mark - privite

+ (instancetype)bridge:(id)webView {
    SHRMWebViewEngine *bridge = [[SHRMWebViewEngine alloc] init];
    bridge.webView = webView;
    [bridge setupInstance];
    [bridge loadStartupPlugin];
    
    if ([webView isKindOfClass:[WKWebView class]]) {
        [bridge configWKWebView:webView];
        [bridge setJavaScriptBridge:bridge];
        return bridge;
    }
    
    if ([webView isKindOfClass:[UIWebView class]]) {
        SHRMUIWebViewJavaScriptBridge *uiBridge = [SHRMUIWebViewJavaScriptBridge bindBridgeWithWebView:webView];
        [uiBridge setWebViewEngine:bridge];
        [bridge setJavaScriptBridge:uiBridge];
        return (SHRMWebViewEngine *)uiBridge;
    }
    [NSException raise:@"BadWebViewType" format:@"Unknown web view type."];
    return nil;
}

- (void)configWKWebView:(WKWebView *)webView {
    webView.navigationDelegate = _WKWebViewDelegate;
    webView.configuration.userContentController = [[WKUserContentController alloc] init];
    [webView.configuration.userContentController addScriptMessageHandler:self name:@"SHRMWKJSBridge"];
}

- (void)setupInstance{
    _webViewhandleFactory = [[SHRMWebViewHandleFactory alloc] initWithWebViewEngine:self];
    _WKWebViewDelegate = [[SHRMWebViewDelegate alloc] initWithWebViewEngine:self];
    _webPluginAnnotation = [[SHRMWebPluginAnnotation alloc] initWithWebViewEngine:self];
    _pluginsMap = [NSMutableDictionary dictionary];
    _commandDelegate = [[SHRMCommandImpl alloc] initWithWebViewEngine:self];
    self.openWhiteList = YES;
}

- (void)loadStartupPlugin {
    [_webPluginAnnotation getAllRegisterPluginName];
}

- (void)registerPlugin:(SHRMBasePlugin *)plugin {
    
    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }
}

- (void)setJavaScriptBridge:(id<SHRMJavaScriptBridgeProtocol>)bridge {
    _bridge = bridge;
}

#pragma mark - dealloc

- (void)dealloc {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *webView = (WKWebView *)self.webView;
        [webView.configuration.userContentController removeScriptMessageHandlerForName:@"SHRMWKJSBridge"];
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSString class]]) {
        [_webViewhandleFactory handleMsgCommand:message.body];
    }
}

#pragma mark - SHRMJavaScriptBridgeProtocol

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id , NSError *))completionHandler {
    WKWebView *webView = (WKWebView *)self.webView;
    [webView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(obj, error);
        }
    }];
}

- (void)reload {
    WKWebView *webView = (WKWebView *)self.webView;
    [webView reload];
}

- (void)setOpenWhiteList:(BOOL)openWhiteList {
    _openWhiteList = openWhiteList;
}


@end
