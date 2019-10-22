//
//  WKJavaScriptBridgeEngine.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKJavaScriptBridgeEngine.h"
#import "WKCommandImpl.h"
#import "WKWeakScriptMessageHandlerDelegate.h"
#import "WKJavaScriptMessageDispatcher.h"
#import "WKJavaScriptPluginAnnotation.h"

static NSString * const WKJSBridgeMessageName = @"WKJSBridgeMessageName";

@interface WKJavaScriptBridgeEngine ()<WKScriptMessageHandler>

@property (nonatomic, strong) WKJavaScriptPluginAnnotation *annotation;
@property (nonatomic, strong) WKJavaScriptMessageDispatcher *dispatcher;
@property (nonatomic, strong) WKCommandImpl *commandDelegate;
@property (nonatomic, strong) NSMutableDictionary *pluginsMap;
@property (nonatomic, weak, readwrite) WKWebView *webView;
@property (nonatomic, weak, readwrite) NSObject <WKNavigationDelegate>*webViewDelegate;

@end

@implementation WKJavaScriptBridgeEngine

#pragma mark - override

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"JSBridgeEngine dealloc");
#endif
    WKWebView *webView = (WKWebView *)self.webView;
    [webView.configuration.userContentController removeScriptMessageHandlerForName:WKJSBridgeMessageName];
}

#pragma mark - public

+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView {
    if ([webView isKindOfClass:[WKWebView class]]) {
        [NSException raise:@"BadWebView" format:@"Unknown web view."];
        return nil;
    }
    WKJavaScriptBridgeEngine *bridge = [[self alloc] initBridgeWithWebView:webView];
    return bridge;
}

#pragma mark - init

- (instancetype)initBridgeWithWebView:(WKWebView *)webView {
    if (self = [super init]) {
        self.webView = webView;
        self.openWhiteList = NO;
        [self commonInit];
        [self setup];
    }
    return self;
}

- (void)commonInit {
    self.dispatcher = [[WKJavaScriptMessageDispatcher alloc] initWithWebViewEngine:self];
    self.annotation = [[WKJavaScriptPluginAnnotation alloc] initWithWebViewEngine:self];
    self.commandDelegate = [[WKCommandImpl alloc] initWithWebViewEngine:self];
    self.pluginsMap = [NSMutableDictionary dictionary];
}

#pragma mark - privite

- (void)setup {
    [self setupJSBridge];
    [self setupPlugin];
}

- (void)setupJSBridge {
    WKWebViewConfiguration *webViewConfiguration = self.webView.configuration;
    if (webViewConfiguration && !webViewConfiguration.userContentController) {
        self.webView.configuration.userContentController = [WKUserContentController new];
    }
    // 防止内存泄露
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WKWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:WKJSBridgeMessageName];
    
    
    self.webView.configuration.userContentController = [[WKUserContentController alloc] init];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:WKJSBridgeMessageName];
}

- (void)setupPlugin {
    [self.annotation getAllRegisterPluginName];
}

- (void)registerPlugin:(WKBasePlugin *)plugin {
    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }
}

#pragma mark - WKJavaScriptBridgeEngineProtocol

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

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id , NSError *))completionHandler {
    WKWebView *webView = (WKWebView *)self.webView;
    [webView evaluateJavaScript:javaScriptString completionHandler:^(id obj, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(obj, error);
        }
    }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSString class]]) {
        [self.dispatcher handleMsgCommand:message.body];
    }
}


@end
