//
//  WKCommandImpl.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKCommandImpl.h"
#import "WKJavaScriptBridgeEngine.h"
#import "WKPluginResult.h"

@implementation WKCommandImpl {
    __weak WKJavaScriptBridgeEngine *_webViewEngine;
    NSRegularExpression* _callbackIdPattern;
}

- (instancetype)initWithWebViewEngine:(WKJavaScriptBridgeEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
        NSError* err = nil;
        
        _callbackIdPattern = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9._-]" options:0 error:&err];
        if (err != nil) {
            // Couldn't initialize Regex
#ifdef DEBUG
            NSLog(@"Error: Couldn't initialize regex");
#endif
            _callbackIdPattern = nil;
        }
    }
    return self;
}

- (void)sendPluginResult:(WKPluginResult *)result callbackId:(NSString*)callbackId {
#ifdef DEBUG
    NSLog(@"Exec(%@): Sending result. Status=%@", callbackId, result.status);
#endif
    // 当本次交互JS侧没有回调时
    if ([@"INVALID" isEqualToString:callbackId]) {
        return;
    }
    // 回调id格式不正确
    if (![self isValidCallbackId:callbackId]) {
#ifdef DEBUG
        NSLog(@"Invalid callback id received by sendPluginResult");
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

- (void)evalJs:(NSString *)js {
    [_webViewEngine evaluateJavaScript:js completionHandler:^(id obj, NSError * error) {
        if (error) {
#ifdef DEBUG
            NSLog(@"evaluateJSError:%@",error.localizedDescription);
#endif
        }
    }];
}

- (id)getCommandInstance:(NSString*)pluginName {
    return [_webViewEngine getCommandInstance:pluginName];
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

- (void)reloadWebView {
    [_webViewEngine.webView reload];
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

@end
