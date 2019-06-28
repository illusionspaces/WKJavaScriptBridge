
//  SHRMFetchPlugin.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMFetchPlugin.h"

@SHRMRegisterWebPlugin(SHRMFetchPlugin)

@implementation SHRMFetchPlugin
- (void)nativeFentch:(SHRMMsgCommand *)command {
    NSString *method = [command.arguments objectForKey:@"method"];
    NSString *url = [command.arguments objectForKey:@"url"];
    
    NSLog(@"method : %@ ; url : %@", method, url);
    
    SHRMPluginResult *result = [SHRMPluginResult resultWithStatus:SHRMCommandStatus_OK messageAsString:@"uiwebview test success!"];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
