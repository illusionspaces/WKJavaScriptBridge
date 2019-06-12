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
@property (nonatomic, strong) NSMutableDictionary *pluginObject;
@property (nonatomic, weak, readwrite) id webView;
@end

@implementation SHRMWebViewEngine

#pragma mark - public

+ (instancetype)bindBridgeWithWebView:(id)webView {
    return [self bridge:webView];
}

- (void)setupPluginName:(NSString *)pluginName onload:(NSNumber *)onload {
    if ([onload boolValue]) {
        [self getCommandInstance:pluginName];
    }
}

- (id)getCommandInstance:(NSString*)pluginName {
    id obj = [_pluginObject objectForKey:[pluginName lowercaseString]];
    
    if (!obj) {
        obj = [[NSClassFromString(pluginName) alloc] initWithWebViewEngine:self];
        
        if (!obj) {
            NSString* fullClassName = [NSString stringWithFormat:@"%@.%@",
                                       NSBundle.mainBundle.infoDictionary[@"CFBundleExecutable"],
                                       pluginName];
            obj = [[NSClassFromString(fullClassName)alloc] init];
        }
        
        if (obj != nil) {
            [self registerPlugin:obj withPluginName:pluginName];
        }else {
            NSLog(@"(pluginName: (%@) does not exist.", pluginName);
        }
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
    _pluginObject = [NSMutableDictionary dictionary];
    _commandDelegate = [[SHRMCommandImpl alloc] initWithWebViewEngine:self];
}

- (void)loadStartupPlugin {
    [_webPluginAnnotation getAllRegisterPluginName];
}

- (void)registerPlugin:(SHRMBasePlugin *)plugin withPluginName:(NSString *)pluginName {
    
    if ([plugin respondsToSelector:@selector(setCommandDelegate:)]) {
        [plugin setCommandDelegate:_commandDelegate];
    }
    
     [_pluginObject setObject:plugin forKey:[pluginName lowercaseString]];
}

- (void)setJavaScriptBridge:(id<SHRMJavaScriptBridgeProtocol>)bridge {
    _bridge = bridge;
}

#pragma mark - dealloc

- (void)dealloc {
    if ([self.webView isKindOfClass:[WKWebView class]]) {
        WKWebView *webView = self.webView;
        [webView.configuration.userContentController removeScriptMessageHandlerForName:@"SHRMWKJSBridge"];
    }
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.body isKindOfClass:[NSArray class]]) {
        [_webViewhandleFactory handleMsgCommand:message.body];
    }
}

#pragma mark - SHRMJavaScriptBridgeProtocol

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id , NSError *))completionHandler {
    WKWebView *webView = self.webView;
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


@end
