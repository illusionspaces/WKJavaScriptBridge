//
//  WKCommandImpl.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKCommandImpl.h"
#import "WKWebViewEngine.h"
#import "WKPluginResult.h"

@implementation WKCommandImpl {
    __weak WKWebViewEngine *_webViewEngine;
    NSRegularExpression* _callbackIdPattern;
}

- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
        NSError* err = nil;
        
        _callbackIdPattern = [NSRegularExpression regularExpressionWithPattern:@"[^A-Za-z0-9._-]" options:0 error:&err];
        if (err != nil) {
            // Couldn't initialize Regex
            NSLog(@"Error: Couldn't initialize regex");
            _callbackIdPattern = nil;
        }
    }
    return self;
}

- (void)sendPluginResult:(WKPluginResult *)result callbackId:(NSString*)callbackId {
    NSLog(@"Exec(%@): Sending result. Status=%@", callbackId, result.status);
    // 当本次交互JS侧没有回调时
    if ([@"INVALID" isEqualToString:callbackId]) {
        return;
    }
    // 回调id格式不正确
    if (![self isValidCallbackId:callbackId]) {
        NSLog(@"Invalid callback id received by sendPluginResult");
        return;
    }
    int status = [result.status intValue];
    NSString* argumentsAsJSON = [result argumentsAsJSON];
    
    NSString* js = [NSString stringWithFormat:@"fetchComplete('(%@)',%d,%@)", callbackId, status, argumentsAsJSON];
    
    if (![NSThread isMainThread]) {
        //不使用GCD是防止js页面死锁产生卡死
        [self performSelectorOnMainThread:@selector(evalJs:) withObject:js waitUntilDone:NO];
    } else {
        [self evalJs:js];
    }
}

- (void)evalJs:(NSString *)js {
    [_webViewEngine.bridge evaluateJavaScript:js completionHandler:^(id obj, NSError * error) {
        if (error) {
            NSLog(@"evaluateJSError:%@",error.localizedDescription);
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
    [_webViewEngine.bridge reload];
}

- (BOOL)isValidCallbackId:(NSString*)callbackId
{
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
