//
//  WKJavaScriptBridgeProtocol.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKMsgCommand;

@protocol WKJavaScriptBridgeProtocol <NSObject>

/**
 注册权限管理插件

 @param name class name
 */
- (void)registerSecurityPlugin:(NSString *)name;

/**
 注册插件安全配置信息

 @param secInfo 配置信息
 */
- (void)registerPluginSecurityInfomation:(NSArray<NSString *>*)secInfo;

/**
 插件安全校验

 @param command 插件信息
 @param completionHandler 结果回调
 */
- (void)pluginSecurityVerityWithCommand:(WKMsgCommand *)command completionHandler:(void (^)(BOOL passed))completionHandler;

/**
 获取模块实例
 
 @param pluginName 模块名称
 @return 模块实例
 */
- (id)getCommandInstance:(NSString*)pluginName;

/**
 执行JavaScript
 
 @param javaScriptString JS函数
 @param completionHandler 结果回调
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

@end

NS_ASSUME_NONNULL_END
