//
//  SHRMIOPlugin.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMIOPlugin.h"

@SHRMRegisterWebPlugin(SHRMIOPlugin, 1);

@implementation SHRMIOPlugin
- (void)nativeIO:(SHRMMsgCommand *)command {
    NSString *method = [command argumentAtIndex:0];
    NSString *url = [command argumentAtIndex:1];
    NSString *param = [command argumentAtIndex:2];
    NSLog(@"(%@):%@,%@,%@",command.callbackId, method, url, param);
    [command.delegate sendPluginResult:@"io success" callbackId:command.callbackId];
}

@end
