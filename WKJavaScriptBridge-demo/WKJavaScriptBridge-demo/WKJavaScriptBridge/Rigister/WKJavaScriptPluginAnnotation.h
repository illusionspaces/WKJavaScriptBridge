//
//  WKJavaScriptPluginAnnotation.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKJavaScriptBridgeEngine;

#define WKWebPlugins "WKWebPlugins"

#define WKWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))
#define WKRegisterWebPlugin(name) \
class WKJavaScriptBridgeEngine; char * k##name##_mod WKWebPluginDATA(WKWebPlugins) = ""#name"";



NS_ASSUME_NONNULL_BEGIN

@interface WKJavaScriptPluginAnnotation : NSObject
- (instancetype)initWithWebViewEngine:(WKJavaScriptBridgeEngine *)webViewEngine;
- (void)getAllRegisterPluginName;
@end

NS_ASSUME_NONNULL_END
