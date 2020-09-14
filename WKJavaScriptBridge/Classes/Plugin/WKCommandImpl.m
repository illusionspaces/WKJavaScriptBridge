//
//  WKCommandImpl.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKCommandImpl.h"
#import "WKJavaScriptBridge.h"
#import "WKPluginResult.h"

@implementation WKCommandImpl {
    __weak WKJavaScriptBridge *_bridge;
    NSRegularExpression* _callbackIdPattern;
}

- (instancetype)initWithBridge:(WKJavaScriptBridge *)bridge {
    if (self = [super init]) {
        _bridge = bridge;
        NSError* err = nil;
        
        _callbackIdPattern = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9._-]" options:0 error:&err];
        if (err != nil) {
            // Couldn't initialize Regex
#ifdef DEBUG
            NSLog(@"WKJavaScriptBridge Error : Couldn't initialize regex");
#endif
            _callbackIdPattern = nil;
        }
    }
    return self;
}

- (void)evalJs:(NSString *)js {
    [_bridge evaluateJavaScript:js completionHandler:^(id obj, NSError * error) {
        if (error) {
#ifdef DEBUG
            NSLog(@"WKJavaScriptBridge Error : 调用JS函数报错 ： %@",error.localizedDescription);
#endif
        }
    }];
}

- (id)getCommandInstance:(NSString*)pluginName {
    return [_bridge getCommandInstance:pluginName];
}

- (BOOL)isValidCallbackId:(NSString*)callbackId {
    if ((callbackId == nil) || (_callbackIdPattern == nil)) {
        return NO;
    }
    
    // 如果太长或发现任何无效字符，则禁用
    if (([callbackId length] > 100) || [_callbackIdPattern firstMatchInString:callbackId options:0 range:NSMakeRange(0, [callbackId length])]) {
        return NO;
    }
    return YES;
}

#pragma mark - WKCommandProtocol

- (void)sendPluginResult:(WKPluginResult *)result callbackId:(NSString*)callbackId {
#ifdef DEBUG
    NSLog(@"WKJavaScriptBridge (%@): Sending result. Status=%@", callbackId, result.status);
#endif
    // 当本次交互JS侧没有回调时
    if ([@"INVALID" isEqualToString:callbackId]) {
        return;
    }
    // 回调id格式不正确
    if (![self isValidCallbackId:callbackId]) {
#ifdef DEBUG
        NSLog(@"WKJavaScriptBridge Error : 通信ID格式不正确，去除无效字符，或检查ID是否过长，限制不得超过100字符。");
#endif
        return;
    }
    
    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
    messageDict[@"status"] = result.status;
    messageDict[@"callbackId"] = callbackId;
    messageDict[@"data"] = result.message;
    
    NSString* argumentsAsJSON = [WKPluginResult jsSerializeWithJson:messageDict];
    NSString* js = [NSString stringWithFormat:@"window.WKJSBridge._handleMessageFromNative('%@')", argumentsAsJSON];
    
    if (![NSThread isMainThread]) {
        //不使用GCD是防止js页面死锁产生卡死
        [self performSelectorOnMainThread:@selector(evalJs:) withObject:js waitUntilDone:NO];
    } else {
        [self evalJs:js];
    }
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (WKWebView *)webView {
    return _bridge.webView;
}

@end
