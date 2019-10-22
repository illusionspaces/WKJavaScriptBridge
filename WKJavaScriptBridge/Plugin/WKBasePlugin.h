//
//  WKBasePlugin.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WKCommandProtocol.h"
#import "WKPluginProtocol.h"
#import "WKMsgCommand.h"
#import "WKJavaScriptBridgePluginAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@class WKJavaScriptBridge;

@interface WKBasePlugin : NSObject<WKPluginProtocol>

@property (nonatomic, weak) id <WKCommandProtocol> commandDelegate;

/**
 插件实例化调用
 */
- (void)pluginInitialize;

/**
 APP 应用终止调用
 */
- (void)onAppTerminate;

/**
 APP 内存警告调用
 */
- (void)onMemoryWarning;

/**
 插件销毁，bridge生命周期结束调用
 */
- (void)dispose;

@end

NS_ASSUME_NONNULL_END
