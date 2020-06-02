//
//  WKCommonPlugin.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKCommonPlugin.h"

@implementation WKCommonPlugin

- (void)asynDisplayCommon:(WKMsgCommand *)command {
    NSString *string = [command.arguments objectForKey:@"url"];
    NSLog(@"url : %@", string);
    
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKJavaScriptBridgeCommandStatus_ERROR messageAsDictionary:@{@"result": @"success!!"}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}


- (void)asyncTestSecurity:(WKMsgCommand *)command {
    NSString *string = [command.arguments objectForKey:@"security"];
    NSLog(@"security : %@", string);
}

@end
