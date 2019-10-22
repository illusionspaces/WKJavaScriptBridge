//
//  WKJavaScriptBridgeEngineProtocol.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WKJavaScriptBridgeEngineProtocol <NSObject>

/**
 模块加载
 
 @param pluginName 模块名称
 */
- (void)setupPluginName:(NSString *)pluginName;

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
