//
//  WKWebPluginAnnotation.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WKWebViewEngine;

#define WKWebPlugins "WKWebPlugins"

#define WKWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))
#define WKRegisterWebPlugin(name) \
class WKWebViewEngine; char * k##name##_mod WKWebPluginDATA(WKWebPlugins) = ""#name"";



NS_ASSUME_NONNULL_BEGIN

@interface WKWebPluginAnnotation : NSObject
- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine;
- (void)getAllRegisterPluginName;
@end

NS_ASSUME_NONNULL_END
