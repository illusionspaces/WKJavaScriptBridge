//
//  WKJavaScriptBridge.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKJavaScriptBridge.h"
#import "WKCommandImpl.h"
#import "WKWeakScriptMessageHandlerDelegate.h"
#import "WKJavaScriptMessageDispatcher.h"
#import "WKJavaScriptBridgePluginAnnotation.h"
#import "WKBasePlugin.h"
#import "WKCommandProtocol.h"

static NSString * const WKJSBridge = @"WKJSBridgeMessageName";

@interface WKJavaScriptBridge ()<WKScriptMessageHandler>

@property (nonatomic, strong) WKJavaScriptBridgePluginAnnotation *annotation;//模块注册白名单
@property (nonatomic, strong) WKJavaScriptMessageDispatcher *dispatcher;//插件模块派发
@property (nonatomic, strong) WKCommandImpl *commandDelegate;//插件模块可执行函数实现
@property (nonatomic, strong) NSMutableDictionary *whiteList;//白名单列表
@property (nonatomic, assign, getter=isOpenWhiteList) BOOL openWhiteList;//是否开启白名单
@property (nonatomic, strong) NSMutableDictionary *pluginsByName;//插件模块实例对象
@property (nonatomic, weak, readwrite) WKWebView *webView;
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation WKJavaScriptBridge

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"WKJavaScriptBridge dealloc");
#endif
    WKWebView *webView = (WKWebView *)self.webView;
    [webView.configuration.userContentController removeScriptMessageHandlerForName:WKJSBridge];
    [[self.pluginsByName allValues] makeObjectsPerformSelector:@selector(dispose)];
    [self.pluginsByName removeAllObjects];
}

#pragma mark - Public

+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView {
    if ([webView isKindOfClass:[WKWebView class]]) {
        WKJavaScriptBridge *bridge = [[self alloc] initBridgeWithWebView:webView];
        return bridge;
    }
    [NSException raise:@"BadWebView" format:@"Unknown web view."];
    return nil;
}

- (void)openWhiteList:(BOOL)openning {
    self.openWhiteList = openning;
}

#pragma mark - Init

- (instancetype)initBridgeWithWebView:(WKWebView *)webView {
    if (self = [super init]) {
        self.webView = webView;
        [self commonInit];
        [self setup];
    }
    return self;
}

- (void)commonInit {
    self.dispatcher = [[WKJavaScriptMessageDispatcher alloc] initWithBridge:self];
    self.annotation = [[WKJavaScriptBridgePluginAnnotation alloc] initWithBridge:self];
    self.commandDelegate = [[WKCommandImpl alloc] initWithBridge:self];
}

#pragma mark - Privite

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
    [self.webView.configuration.userContentController addScriptMessageHandler:[[WKWeakScriptMessageHandlerDelegate alloc] initWithDelegate:self] name:WKJSBridge];
}

- (void)setupPlugin {
    [self.annotation getAllRegisterPluginName];
}

- (void)registerPlugin:(WKBasePlugin *)plugin {
    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }
}

- (Class)pluginImplClass:(NSString *)pluginName {
    if (pluginName.length > 0) {
        return NSClassFromString(pluginName);
    }
    return nil;
}

- (BOOL)pluginShouldCache:(Class)implClass {
    BOOL shouldCache = NO;
    if ([[implClass class] respondsToSelector:@selector(shouldCache)]) {
        if ([[implClass class] shouldCache]) {
            shouldCache = YES;
        }
    }
    return shouldCache;
}

- (void)pluginInstall:(WKBasePlugin *)plugin {
    [plugin pluginInitialize];
    [self registerPlugin:plugin];
}

#pragma mark - WKJavaScriptBridgeProtocol

- (void)addWhiteList:(NSString *)pluginName {
    [self.lock lock];
    [self.whiteList setValue:pluginName forKey:[pluginName lowercaseString]];
    [self.lock unlock];
}

- (id)getCommandInstance:(NSString*)pluginName {
    NSString* className;
    if (self.isOpenWhiteList) {//校验白名单
        [self.lock lock];
        className = [self.whiteList objectForKey:[pluginName lowercaseString]];
        [self.lock unlock];
        if (className == nil) {
#ifdef DEBUG
            NSLog(@"WKJavaScriptBridge Error : 模块: (%@) 没有注册白名单。请关闭白名单或者或者使用（@WKRegisterWhiteList）注册。", pluginName);
#endif
            return nil;
        }
    }else {
        className = pluginName;
    }
    
    WKBasePlugin <WKPluginProtocol> *plugin = nil;
    Class implClass = [self pluginImplClass:pluginName];
    
    BOOL shouldCache = [self pluginShouldCache:implClass];
    if (shouldCache) {
        plugin = [self.pluginsByName objectForKey:className];
        if (plugin) {
            return plugin;
        }
    }
    
    if ([[implClass class] respondsToSelector:@selector(singleton)]) {
        if ([[implClass class] singleton]) {
            if ([[implClass class] respondsToSelector:@selector(shareInstance)])
                plugin = [[implClass class] shareInstance];
            else
                plugin = [[implClass alloc] init];
            
            if (plugin) {
                [self pluginInstall:plugin];
                if (shouldCache) {
                    [self.pluginsByName setObject:plugin forKey:className];
                }
            }else {
#ifdef DEBUG
                NSLog(@"WKJavaScriptBridge Error : 模块: (%@) 不存在。", pluginName);
#endif
            }
            return plugin;
        }
    }
    
    plugin = [[implClass alloc] init];
    if (plugin) {
        [self pluginInstall:plugin];
        if (shouldCache) {
            [self.pluginsByName setObject:plugin forKey:className];
        }
    }else {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 模块: (%@) 不存在。", pluginName);
#endif
    }
    return plugin;
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
    if ([message.name isEqualToString:WKJSBridge]) {
        if ([message.body isKindOfClass:[NSString class]]) {
            [self.dispatcher handleMsgCommand:message.body];
        }else {
#ifdef DEBUG
            NSLog(@"WKJavaScriptBridge Error : 通信参数不合法，请将JS侧参数转为字符串通信。");
#endif
        }
    }else {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 本次调用所使用的JS函数非（WKJavaScriptBridge）注入。请使用（%@）",WKJSBridge);
#endif
    }
}

#pragma mark - Set or Get

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

- (NSMutableDictionary *)whiteList {
    if (!_whiteList) {
        _whiteList = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _whiteList;
}

- (NSMutableDictionary *)pluginsByName {
    if (!_pluginsByName) {
        _pluginsByName = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _pluginsByName;
}

@end
