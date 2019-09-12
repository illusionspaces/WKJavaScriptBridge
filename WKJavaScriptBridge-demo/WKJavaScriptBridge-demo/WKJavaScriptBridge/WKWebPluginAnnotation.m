//
//  WKWebPluginAnnotation.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKWebPluginAnnotation.h"
#import "WKWebViewEngine.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

@implementation WKWebPluginAnnotation

__weak WKWebViewEngine *_webViewEngine;

- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
    }
    return self;
}

- (void)getAllRegisterPluginName {
    [self registedAnnotationModules];
}

- (void)registedAnnotationModules {
    NSArray<NSString *>*services = [WKWebPluginAnnotation AnnotationModules];
    for (NSString *pluginName in services) {
        if (pluginName) {
            [_webViewEngine setupPluginName:pluginName];
        }
    }
}

+ (NSArray<NSString *> *)AnnotationModules {
    static NSArray<NSString *> *mods = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mods = BHReadConfiguration(WKWebPlugins);
    });
    return mods;
}

static NSArray<NSString *>* BHReadConfiguration(char *section) {
    NSMutableArray *configs = [NSMutableArray array];
    
    Dl_info info;
    dladdr(BHReadConfiguration, &info);
    
#ifndef __LP64__
    const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
    unsigned long size = 0;
    uint32_t *memory = (uint32_t*)getsectiondata(mhp, "__DATA", section, & size);
#else /* defined(__LP64__) */
    const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
    unsigned long size = 0;
    uint64_t *memory = (uint64_t*)getsectiondata(mhp, "__DATA", section, & size);
#endif /* defined(__LP64__) */
    for(int idx = 0; idx < size/sizeof(void*); ++idx){
        char *string = (char*)memory[idx];
        
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        NSLog(@"config = %@", str);
        if(str) [configs addObject:str];
    }
    
    return configs;
}

@end
