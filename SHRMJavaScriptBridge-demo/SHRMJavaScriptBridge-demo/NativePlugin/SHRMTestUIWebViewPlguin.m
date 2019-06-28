//
//  SHRMTestUIWebVIewPlguin.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMTestUIWebViewPlguin.h"

@SHRMRegisterWebPlugin(SHRMTestUIWebViewPlguin)

@implementation SHRMTestUIWebViewPlguin
- (void)nativeTestUIWebView:(SHRMMsgCommand *)command {
    NSString *method = [command.arguments objectForKey:@"method"];
    NSString *url = [command.arguments objectForKey:@"url"];

    SHRMPluginResult *result = [SHRMPluginResult resultWithStatus:SHRMCommandStatus_OK messageAsString:@"uiwebview test success!"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
