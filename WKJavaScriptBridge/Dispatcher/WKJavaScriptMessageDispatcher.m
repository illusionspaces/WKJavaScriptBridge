//
//  WKJavaScriptMessageDispatcher.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKJavaScriptMessageDispatcher.h"
#import "WKMsgCommand.h"
#import "WKJavaScriptBridge.h"
#import "WKBasePlugin.h"
#import "NSString+BridgeJSONPrivate.h"
#import <objc/message.h>

static const NSInteger JSON_SIZE_FOR_MAIN_THREAD = 4 * 1024; // Chosen arbitrarily.

@implementation WKJavaScriptMessageDispatcher {
    __weak WKJavaScriptBridge *_bridge;
    NSDictionary *_commandDictionary;
}

- (instancetype)initWithBridge:(WKJavaScriptBridge *)bridge {
    if (self = [super init]) {
        _bridge = bridge;
        _commandDictionary = [NSDictionary dictionary];
    }
    return self;
}

- (void)handleMsgCommand:(NSString *)arguments {
    [self handleCommand:arguments];
}

#pragma mark - handle

- (void)handleCommand:(NSString *)commandJson {
    if (commandJson.length > 0) {
        [self fetchCommands:commandJson];
        [self executePending];
    }
}

- (void)fetchCommands:(NSString *)command {
    
    if ([command length] < JSON_SIZE_FOR_MAIN_THREAD) {
        _commandDictionary = [command bridge_JSONObject];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
            self->_commandDictionary = [command bridge_JSONObject];
            [self performSelectorOnMainThread:@selector(executePending) withObject:nil waitUntilDone:NO];
        });
    }
}

- (void)executePending {
    if (_commandDictionary.allKeys.count > 0) {
        WKMsgCommand *msgCommand = [WKMsgCommand commandFromJson:_commandDictionary];
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge(%@): Calling %@.%@", msgCommand.callbackId, msgCommand.className, msgCommand.methodName);
#endif
        if (![self execute:msgCommand]) {
#ifdef DEBUG
            NSString *commandJson = [NSString stringWithFormat:@"%@",_commandDictionary];
            static NSUInteger maxLogLength = 1024;
            NSString *commandString = ([commandJson length] > maxLogLength) ?
            [NSString stringWithFormat : @"%@[...]", [commandJson substringToIndex:maxLogLength]] :
            commandJson;
            
            NSLog(@"WKJavaScriptBridge Error : FAILED pluginJSON = %@", commandString);
#endif
        }
    }
}

- (BOOL)execute:(WKMsgCommand *)command {
    if (command.className == nil || command.methodName == nil) {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 调用的类名或方法名不存在。");
#endif
        return NO;
    }
    
    BOOL retVal = YES;
    double started = [[NSDate date] timeIntervalSince1970] * 1000.0;
    
    WKBasePlugin *instance = [_bridge getCommandInstance:command.className];
    
    if (!([instance isKindOfClass:[WKBasePlugin class]])) {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 模块 '%@' 异常, 检查此模块是否继承于（WKBasePlugin）", command.className);
#endif
        return NO;
    }
    
    NSString* methodName = [NSString stringWithFormat:@"%@:", command.methodName];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([instance respondsToSelector:normalSelector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(instance, normalSelector, command);
    } else {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 函数 '%@' 在类 '%@' 中没有找到。", methodName, command.className);
#endif
        retVal = NO;
    }
    double elapsed = [[NSDate date] timeIntervalSince1970] * 1000.0 - started;
    if (elapsed > 10) {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge THREAD WARNING: ['%@'] 占用了 '%f' ms。请使用（runInBackground:）将此插件放到后台执行。", command.className, elapsed);
#endif
    }
    return retVal;
}

- (void)dealloc {
    _bridge = nil;
}
@end
