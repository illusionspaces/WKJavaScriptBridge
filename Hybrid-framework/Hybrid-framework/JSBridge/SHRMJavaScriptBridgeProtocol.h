//
//  SHRMJavaScriptBridgeProtocol.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHRMJavaScriptBridgeProtocol <NSObject>
/**
 native 调用 js 接口
 
 @param result simulate data
 @param callbackId callbackId
 */
- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId;
@end

NS_ASSUME_NONNULL_END
