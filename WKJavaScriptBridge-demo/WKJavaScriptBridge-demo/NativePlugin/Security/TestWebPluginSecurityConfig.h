//
//  TestWebPluginSecurityConfig.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2020/6/2.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "WKJavaScriptBridgePluginAnnotation.h"

#ifndef TestWebPluginSecurityConfig_h
#define TestWebPluginSecurityConfig_h

// 配置安全插件
//@WKConfigSafePlugin(TestSecurityPlugin)

// 配置插件白名单：类名 方法名 安全级别
// B级
@WKConfigPluginSafeLevel(WKCommonPlugin,asyncTestSecurity,2)
// C级
@WKConfigPluginSafeLevel(WKCommonPlugin,asynDisplayCommon,3)

#endif /* TestWebPluginSecurityConfig_h */
