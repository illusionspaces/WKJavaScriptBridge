//
//  SHRMWebViewEngine.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SHRMWebPluginAnnotation.h"
#import "SHRMWebViewCookieMgr.h"
#import "SHRMCommandProtocol.h"
#import "SHRMJavaScriptBridgeProtocol.h"
#import "SHRMWebViewHandleFactory.h"

#define WVJB_WEBVIEW_DELEGATE_TYPE NSObject<UIWebViewDelegate>

NS_ASSUME_NONNULL_BEGIN

@class SHRMWebViewHandleFactory;

@interface SHRMWebViewEngine : NSObject<WKScriptMessageHandler, SHRMJavaScriptBridgeProtocol>

@property (nonatomic, readonly, strong) id <SHRMCommandProtocol> commandDelegate;
@property (nonatomic, readonly, strong) SHRMWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, readonly, strong) id <SHRMJavaScriptBridgeProtocol>bridge;

/**
 外部提供的webView
 */
@property (nonatomic, weak, readonly) id webView;


/**
 webView容器
 */
@property (nonatomic, weak) id webViewDelegate;

/**
 webView绑定 bridge初始化

 @param webView WKWebView & UIWebView
 @return bridge
 */
+ (instancetype)bindBridgeWithWebView:(id)webView;

/**
 插件预加载接口 onload 为 1 表示提前初始化此插件对象 否则在调用时初始化
 
 @param pluginName name
 @param onload onload
 */
- (void)setupPluginName:(NSString *)pluginName onload:(NSNumber *)onload;

/**
 获取plugin实例

 @param pluginName plugin name
 @return instance
 */
- (id)getCommandInstance:(NSString*)pluginName;
@end

NS_ASSUME_NONNULL_END
