//
//  WKPluginSecurityProtocol.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2020/6/2.
//  Copyright © 2020 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PHJudgeAuthorityComplete)(BOOL allowed);

NS_ASSUME_NONNULL_BEGIN

@protocol WKPluginSecurityProtocol <NSObject>

@required

/**
 插件是否符合使用权限
 
 @param serviceName 类名
 @param actionName 方法名
 @param completionHandler 校验结果，异步返回
 */
- (void)applyAuthorityWithService:(NSString *)serviceName action:(NSString *)actionName securityInfomation:(NSArray<NSString *>*)secInfo complete:(PHJudgeAuthorityComplete)completionHandler;

@end

NS_ASSUME_NONNULL_END
