//
//  SHRMWebViewHandleFactory.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebViewHandleFactory.h"
#import "SHRMMsgCommand.h"
#import "SHRMWebViewEngine.h"
#import <objc/message.h>

@implementation SHRMWebViewHandleFactory {
    __weak SHRMWebViewEngine *_webViewEngine;
}

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
    }
    return self;
}

- (void)handleMsgCommand:(NSArray *)arguments {
    [self handleCommand:arguments];
}

#pragma mark - handle

- (void)handleCommand:(NSArray *)commandArray {
    if (commandArray.count > 0) {
        [self executePending:commandArray];
    }
}

- (void)executePending:(NSArray *)command {
    SHRMMsgCommand *msgCommand = [SHRMMsgCommand commandFromJson:command];
    if (![self execute:msgCommand]) {
        NSLog(@"%@.%@ execute fail",msgCommand.className, msgCommand.methodName);
    }
}

- (BOOL)execute:(SHRMMsgCommand *)command {
    if (command.className == nil || command.methodName == nil) {
        NSLog(@"ERROR: Classname and/or methodName not found for command.");
        return NO;
    }
    
    BOOL retVal = YES;
    double started = [[NSDate date] timeIntervalSince1970] * 1000.0;
    
    id instance = [_webViewEngine.commandDelegate getCommandInstance:command.className];

    NSString* methodName = [NSString stringWithFormat:@"%@:", command.methodName];
    SEL normalSelector = NSSelectorFromString(methodName);
    if ([instance respondsToSelector:normalSelector]) {
        ((void (*)(id, SEL, id))objc_msgSend)(instance, normalSelector, command);
    } else {
        NSLog(@"ERROR: Method '%@' not defined in Plugin '%@'", methodName, command.className);
        retVal = NO;
    }
    double elapsed = [[NSDate date] timeIntervalSince1970] * 1000.0 - started;
    if (elapsed > 10) {
        NSLog(@"THREAD WARNING: ['%@'] took '%f' ms. Plugin should use a background thread.", command.className, elapsed);
    }
    return retVal;
}

- (void)dealloc {
    _webViewEngine = nil;
}

@end
