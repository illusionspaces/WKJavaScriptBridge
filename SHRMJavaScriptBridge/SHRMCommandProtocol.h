//
//  SHRMCommandProtocol.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMMsgCommand.h"
#import "SHRMPluginResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SHRMCommandProtocol <NSObject>

/**
 native 调用 js 接口
 
 @param result simulate data
 @param callbackId callbackId
 */
- (void)sendPluginResult:(SHRMPluginResult *)result callbackId:(NSString*)callbackId;

/**
 封装个子线程接口 执行耗时插件
 
 @param block long running
 */
- (void)runInBackground:(void (^)(void))block;

/**
 获取插件plugin的实例对象
 
 @param pluginName 插件名称
 @return 实例对象
 */
- (id)getCommandInstance:(NSString*)pluginName;

/**
 刷新webView
 */
- (void)reloadWebView;

@end

NS_ASSUME_NONNULL_END
