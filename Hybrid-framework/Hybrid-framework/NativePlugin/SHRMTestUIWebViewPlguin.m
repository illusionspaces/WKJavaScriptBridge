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
    [self.commandDelegate sendPluginResult:@"uiwebview test success!" callbackId:command.callbackId];
}
@end
