//
//  SHRMUIWebViewJavaScriptBridge.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/14.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SHRMJavaScriptBridgeProtocol.h"
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@class SHRMWebViewEngine;

@interface SHRMUIWebViewJavaScriptBridge : NSObject <SHRMJavaScriptBridgeProtocol>
+ (instancetype)bindBridgeWithWebView:(UIWebView *)webView;
/**
 webView容器
 */
@property (nonatomic, weak) id webViewDelegate;
- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine;
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*)ctx;
@end

NS_ASSUME_NONNULL_END
