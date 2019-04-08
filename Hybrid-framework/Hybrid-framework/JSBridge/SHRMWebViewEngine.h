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
 使用hybrid能力的viewController
 */
@property (nonatomic, weak) id delegate;


/**
 webView js注入

 @param webView webView
 */
- (void)bindBridgeWithWebView:(WKWebView *)webView;

/**
 获取插件plugin的实例对象

 @param pluginName 插件名称
 @return 实例对象
 */
- (id)getCommandInstance:(NSString*)pluginName;
@end

NS_ASSUME_NONNULL_END
