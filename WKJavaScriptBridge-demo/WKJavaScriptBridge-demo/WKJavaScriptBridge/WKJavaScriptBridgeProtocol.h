//
//  WKJavaScriptBridgeProtocol.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WKJavaScriptBridgeProtocol <NSObject>

/**
 执行JS

 @param javaScriptString js
 @param completionHandler 结果回调
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;

/**
 插件加载
 
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
