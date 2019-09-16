//
//  WKWebViewHandleFactory.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKWebViewHandleFactory.h"
#import "WKMsgCommand.h"
#import "WKWebViewEngine.h"
#import <objc/message.h>

static const NSInteger JSON_SIZE_FOR_MAIN_THREAD = 4 * 1024; // Chosen arbitrarily.

@implementation WKWebViewHandleFactory {
    __weak WKWebViewEngine *_webViewEngine;
    NSDictionary *_commandDictionary;
}

- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
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
        _commandDictionary = [self JSONObject:command];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
            self->_commandDictionary = [self JSONObject:command];
            [self performSelectorOnMainThread:@selector(executePending) withObject:nil waitUntilDone:NO];
        });
    }
}

- (void)executePending {
    if (_commandDictionary.allKeys.count > 0) {
        WKMsgCommand *msgCommand = [WKMsgCommand commandFromJson:_commandDictionary];
#ifdef DEBUG
        NSLog(@"Exec(%@): Calling %@.%@", msgCommand.callbackId, msgCommand.className, msgCommand.methodName);
#endif
        if (![self execute:msgCommand]) {
#ifdef DEBUG
            NSString *commandJson = [NSString stringWithFormat:@"%@",_commandDictionary];
            static NSUInteger maxLogLength = 1024;
            NSString *commandString = ([commandJson length] > maxLogLength) ?
            [NSString stringWithFormat : @"%@[...]", [commandJson substringToIndex:maxLogLength]] :
            commandJson;
            
            NSLog(@"FAILED pluginJSON = %@", commandString);
#endif
        }
    }
}

- (BOOL)execute:(WKMsgCommand *)command {
    if (command.className == nil || command.methodName == nil) {
#ifdef DEBUG
        NSLog(@"ERROR: Classname and/or methodName not found for command.");
#endif
        return NO;
    }
    
    BOOL retVal = YES;
    double started = [[NSDate date] timeIntervalSince1970] * 1000.0;
    
    WKBasePlugin *instance = [_webViewEngine.commandDelegate getCommandInstance:command.className];
    
    if (!([instance isKindOfClass:[WKBasePlugin class]])) {
#ifdef DEBUG
        NSLog(@"ERROR: Plugin '%@' not found, or is not a Plugin. Check your plugin mapping in config.xml.", command.className);
#endif
        return NO;
    }
    
    NSString* methodName = [NSString stringWithFormat:@"%@:", command.methodName];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([instance respondsToSelector:normalSelector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(instance, normalSelector, command);
    } else {
#ifdef DEBUG
        NSLog(@"ERROR: Method '%@' not defined in Plugin '%@'", methodName, command.className);
#endif
        retVal = NO;
    }
    double elapsed = [[NSDate date] timeIntervalSince1970] * 1000.0 - started;
    if (elapsed > 10) {
#ifdef DEBUG
        NSLog(@"THREAD WARNING: ['%@'] took '%f' ms. Plugin should use a background thread.", command.className, elapsed);
#endif
    }
    return retVal;
}

- (void)dealloc {
    _webViewEngine = nil;
}

- (id)JSONObject:(NSString *)json
{
    @autoreleasepool {
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        
        if (error != nil) {
#ifdef DEBUG
            NSLog(@"NSString JSONObject error: %@, Malformed Data: %@", [error localizedDescription], self);
#endif
        }
        
        return object;
    }
}

@end
