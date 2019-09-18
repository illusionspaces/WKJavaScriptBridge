//
//  WKJSBridgeConfig.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/9/18.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKJSBridgeConfig.h"

@WKRegisterWebPlugin(WKJSBridgeConfig)

@implementation WKJSBridgeConfig

- (void)fetchConfig:(WKMsgCommand *)command {
    NSDictionary *dict = @{
                           @"fetch_id":@{//服务ID
                                   @"service":@"WKFetchPlugin",
                                   @"action":@{//具体事件
                                           @"action_get":@"nativeGet",
                                           @"action_post":@"nativePost"
                                           }
                                   }
                           };
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
