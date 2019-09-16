
//  WKFetchPlugin.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKFetchPlugin.h"

@WKRegisterWebPlugin(WKFetchPlugin)

@implementation WKFetchPlugin
- (void)nativeFentch:(WKMsgCommand *)command {
    NSString *method = [command.arguments objectForKey:@"method"];
    NSString *url = [command.arguments objectForKey:@"url"];
    
    NSLog(@"method : %@ ; url : %@", method, url);
    
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKCommandStatus_ERROR messageAsDictionary:@{@"result": @"success!!"}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
