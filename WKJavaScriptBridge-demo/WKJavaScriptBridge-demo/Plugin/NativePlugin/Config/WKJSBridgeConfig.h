//
//  WKJSBridgeConfig.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/9/18.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKJSBridgeConfig : WKBasePlugin
- (void)fetchConfig:(WKMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END
