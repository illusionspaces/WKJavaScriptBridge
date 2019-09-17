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

@interface WKWebViewEngine : NSObject

@property (nonatomic, readonly, strong) id <WKCommandProtocol> commandDelegate;
@property (nonatomic, readonly, strong) id <WKJavaScriptBridgeProtocol>bridge;

/** 是否开启插件白名单，默认开启 */
@property (nonatomic, assign, getter=isOpenWhiteList) BOOL openWhiteList;

/** 外部提供的webView */
@property (nonatomic, readonly, weak) WKWebView *webView;

/** webView的容器 */
@property (nonatomic, readonly, weak) NSObject <WKNavigationDelegate>*webViewDelegate;

/**
 初始化方法

 @param webView webView
 @param webViewDelegate 实现webView代理的类，没有可传空
 @return bridge
 */
+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView withDelegate:(NSObject <WKNavigationDelegate>*)webViewDelegate;

@end

NS_ASSUME_NONNULL_END
