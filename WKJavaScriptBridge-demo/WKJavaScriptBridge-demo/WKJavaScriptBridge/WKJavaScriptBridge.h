//
//  WKJavaScriptBridge.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKJavaScriptBridgeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKJavaScriptBridge : NSObject<WKJavaScriptBridgeProtocol>

/** 外部提供的webView，只读 */
@property (nonatomic, readonly, weak) WKWebView *webView;

/**
 初始化绑定方法
 
 @param webView webView
 @return bridge
 */
+ (instancetype)bindBridgeWithWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
