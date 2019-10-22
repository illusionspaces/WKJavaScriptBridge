//
//  WKJavaScriptBridgePluginAnnotation.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKJavaScriptBridge;

#define WKWebPlugins "WKWebPlugins"

#define WKWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))
#define WKRegisterWhiteList(name) \
class WKJavaScriptBridge; char * k##name##_mod WKWebPluginDATA(WKWebPlugins) = ""#name"";



NS_ASSUME_NONNULL_BEGIN

@interface WKJavaScriptBridgePluginAnnotation : NSObject
- (instancetype)initWithBridge:(WKJavaScriptBridge *)bridge;
- (void)getAllRegisterPluginName;
@end

NS_ASSUME_NONNULL_END
