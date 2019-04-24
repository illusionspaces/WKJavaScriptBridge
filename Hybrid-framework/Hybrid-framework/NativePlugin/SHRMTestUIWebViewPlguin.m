//
//  SHRMTestUIWebVIewPlguin.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMTestUIWebViewPlguin.h"

@SHRMRegisterWebPlugin(SHRMTestUIWebViewPlguin, 1)

@implementation SHRMTestUIWebViewPlguin
- (void)nativeTestUIWebView:(SHRMMsgCommand *)command {
    NSString *method = [command argumentAtIndex:0];
    NSString *url = [command argumentAtIndex:1];
    NSString *param = [command argumentAtIndex:2];
    NSLog(@"(%@):%@,%@,%@",command.callbackId, method, url, param);
    SHRMPluginResult *result = [SHRMPluginResult resultWithStatus:SHRMCommandStatus_OK messageAsDictionary:@{@"success" : @"uiwebview test success!"}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
