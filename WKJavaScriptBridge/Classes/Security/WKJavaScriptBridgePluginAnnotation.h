//
//  WKJavaScriptBridgePluginAnnotation.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class WKJavaScriptBridge;
//
//#define WKWebPlugins "WKWebPlugins"
//
//#define WKWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))
//#define WKRegisterWhiteList(name) \
//class WKJavaScriptBridge; char * k##name##_mod WKWebPluginDATA(WKWebPlugins) = ""#name"";



@class WKJavaScriptBridge;

#define SecurityConfig "SecurityConfig"

#define SecurityPlugin "SecurityPlugin"

#define WKWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define WKConfigPluginSafeLevel(service,action,level) \
class WKJavaScriptBridge;char * k##service##_##action##_plu WKWebPluginDATA(SecurityConfig) = "[\""#service"\",\""#action"\",\""#level"\"]";

#define WKConfigSafePlugin(name) \
class PHJavaScriptBridge;char * k##name##_plu WKWebPluginDATA(SecurityPlugin) = ""#name"";

NS_ASSUME_NONNULL_BEGIN

@interface WKJavaScriptBridgePluginAnnotation : NSObject
- (instancetype)initWithBridge:(WKJavaScriptBridge *)bridge;
- (void)getAllRegisterPluginName;
@end

NS_ASSUME_NONNULL_END
