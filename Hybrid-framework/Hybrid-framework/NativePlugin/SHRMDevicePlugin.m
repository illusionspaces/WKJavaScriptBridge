//
//  SHRMDevicePlugin.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMDevicePlugin.h"

@SHRMRegisterWebPlugin(SHRMDevicePlugin, 1)

@implementation SHRMDevicePlugin
- (void)nativeDevice:(SHRMMsgCommand *)command {
    NSString *method = [command argumentAtIndex:0];
    NSString *url = [command argumentAtIndex:1];
    NSString *param = [command argumentAtIndex:2];
    NSLog(@"(%@):%@,%@,%@",command.callbackId, method, url, param);
    [self.commandDelegate sendPluginResult:@"device seccess" callbackId:command.callbackId];
}
@end
