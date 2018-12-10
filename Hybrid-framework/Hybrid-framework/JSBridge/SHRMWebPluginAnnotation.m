//
//  SHRMWebPluginAnnotation.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebPluginAnnotation.h"
#import "SHRMWebViewEngine.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>

@implementation SHRMWebPluginAnnotation

__weak SHRMWebViewEngine *_webViewEngine;

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
    }
    return self;
}

- (void)getAllRegisterPluginName {
    _dyld_register_func_for_add_image(dyld_callback);
}

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    NSArray<NSString *> *services = ReadConfiguration(SHRMWebPlugins,mhp);
    for (NSString *map in services) {
        NSData *jsonData =  [map dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            return;
        }
        if (![json isKindOfClass:[NSDictionary class]] || [json allKeys].count < 1) {
            return;
        }
        
        NSString *pluginName = [json allKeys][0];
        NSNumber *onload  = [json allValues][0];
        
        if (pluginName && onload) {
            [_webViewEngine registerStartupPluginName:pluginName onload:onload];
        }
    }
}

NSArray<NSString *>* ReadConfiguration(char *sectionName,const struct mach_header *mhp) {
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        NSLog(@"config = %@", str);
        if(str) [configs addObject:str];
    }
    return configs;
}

@end
