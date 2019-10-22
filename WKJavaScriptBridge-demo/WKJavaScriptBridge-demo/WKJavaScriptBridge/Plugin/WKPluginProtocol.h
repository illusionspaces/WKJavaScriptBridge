//
//  WKPluginProtocol.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WKPluginProtocol <NSObject>

@optional

/**
 设置插件为多例
 
 @return 默认YES
 */
+ (BOOL)singleton;

/**
 设置插件为单例
 
 @return 默认NO
 */
+ (id)shareInstance;

/**
 设置插件缓存
 
 @return 默认YES，为YES时生命周期跟随Bridge
 */
+ (BOOL)shouldCache;

@end

NS_ASSUME_NONNULL_END
