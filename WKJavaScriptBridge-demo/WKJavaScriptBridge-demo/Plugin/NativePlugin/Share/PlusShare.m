//
//  PlusShare.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/9/20.
//  Copyright © 2019 王凯. All rights reser/Users/kevin/Project/WKJavaScriptBridge/WKJavaScriptBridge-demo/WKJavaScriptBridge-demo/Plugin/NativePlugin/PlusShare.h/Users/kevin/Project/WKJavaScriptBridge/WKJavaScriptBridge-demo/WKJavaScriptBridge-demo/Plugin/NativePlugin/PlusShare.mved.
//

#import "PlusShare.h"

@WKRegisterWebPlugin(PlusShare)

@implementation PlusShare

- (void)getServices:(WKMsgCommand *)command {
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKCommandStatus_OK messageAsDictionary:@{@"list":@[@"sinaweibo",@"tencentweibo",@"weixin"]}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)sendWithSystem:(WKMsgCommand *)command {
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKCommandStatus_OK messageAsDictionary:@{@"result":@"分享成功"}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
