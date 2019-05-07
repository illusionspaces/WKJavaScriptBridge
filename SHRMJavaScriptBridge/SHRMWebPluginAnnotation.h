//
//  SHRMWebPluginAnnotation.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SHRMWebViewEngine;

#define SHRMWebPlugins "SHRMWebPlugins"

#define SHRMWebPluginDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))
#define SHRMRegisterWebPlugin(servicename,impl) \
class SHRMWebViewEngine;char * k##servicename##_service SHRMWebPluginDATA(SHRMWebPlugins) = "{ \""#servicename"\" : \""#impl"\"}";



NS_ASSUME_NONNULL_BEGIN

@interface SHRMWebPluginAnnotation : NSObject
- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine;
- (void)getAllRegisterPluginName;
@end

NS_ASSUME_NONNULL_END
