//
//  WKJavaScriptBridgeEngine.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKCommandProtocol.h"
#import "WKBasePlugin.h"
#import "WKJavaScriptBridgeEngineProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKJavaScriptBridgeEngine : NSObject<WKJavaScriptBridgeEngineProtocol>

/** 是否开启插件白名单，默认关闭 */
@property (nonatomic, assign, getter=isOpenWhiteList) BOOL openWhiteList;

/** 外部提供的webView */
@property (nonatomic, readonly, weak) WKWebView *webView;

/**
 初始化绑定方法

 @param webView webView
 @return bridge
 */
+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
