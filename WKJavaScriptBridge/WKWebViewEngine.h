//
//  WKWebViewEngine.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKWebPluginAnnotation.h"
#import "WKWebViewCookieMgr.h"
#import "WKCommandProtocol.h"
#import "WKJavaScriptBridgeProtocol.h"
#import "WKWebViewHandleFactory.h"
#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class WKWebViewHandleFactory;

@interface WKWebViewEngine : NSObject <WKScriptMessageHandler, WKJavaScriptBridgeProtocol>

@property (nonatomic, readonly, strong) id <WKCommandProtocol> commandDelegate;
@property (nonatomic, readonly, strong) WKWebViewHandleFactory *webViewhandleFactory;
@property (nonatomic, readonly, strong) id <WKJavaScriptBridgeProtocol>bridge;

/**
 是否开启插件白名单，默认开启
 */
@property (nonatomic, assign, getter=isOpenWhiteList) BOOL openWhiteList;
/**
 外部提供的webView
 */
@property (nonatomic, readonly, weak) WKWebView *webView;

/**
 webView容器VC
 */
@property (nonatomic, weak) id webViewDelegate;

/**
 webView绑定 bridge初始化
 
 @param webView WKWebView
 @return bridge
 */
+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView;

/**
 插件预加载接口 onload 为 1 表示提前初始化此插件对象 否则在调用时初始化
 
 @param pluginName name
 */
- (void)setupPluginName:(NSString *)pluginName;

/**
 获取plugin实例
 
 @param pluginName plugin name
 @return instance
 */
- (id)getCommandInstance:(NSString*)pluginName;

@end

NS_ASSUME_NONNULL_END
