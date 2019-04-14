//
//  SHRMWebViewEngine.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SHRMWebViewProtocol.h"
#import "SHRMWebPluginAnnotation.h"
#import "SHRMWebViewCookieMgr.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRMWebViewEngine : NSObject<WKScriptMessageHandler, SHRMWebViewProtocol>

/**
 外部提供的webView
 */
@property (nonatomic, weak, readonly) WKWebView *webView;


/**
 webView容器
 */
@property (nonatomic, weak) id webViewDelegate;

/**
 使用hybrid能力的viewController
 */
- (void)setWebViewDelegate:(id)webViewDelegate;

/**
 获取插件plugin的实例对象

 @param pluginName 插件名称
 @return 实例对象
 */
- (id)getCommandInstance:(NSString*)pluginName;

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
- (void)registerStartupPluginName:(NSString *)pluginName onload:(NSNumber *)onload;
@end

NS_ASSUME_NONNULL_END
