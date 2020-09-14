//
//  WKCommandProtocol.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKPluginResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WKCommandProtocol <NSObject>

/**
 原生模块回调js
 
 @param result simulate data
 @param callbackId callbackId
 */
- (void)sendPluginResult:(WKPluginResult *)result callbackId:(NSString*)callbackId;

/**
 原生模块执行耗时操作
 
 @param block long running
 */
- (void)runInBackground:(void (^)(void))block;

/**
 和Bridge绑定的webView

 @return WKWebView
 */
- (WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
