//
//  TestSecurityPlugin.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2020/6/2.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "TestSecurityPlugin.h"

@interface TestSecurityPlugin ()

@property (nonatomic, strong) NSMutableDictionary *securityConfig;//白名单注册表
@property (nonatomic, strong) NSRecursiveLock *lock;

@end

NSString *const kPluginSecurityActionKey = @"action";
NSString *const kPluginSecuritylevelKey = @"level";

@implementation TestSecurityPlugin

#pragma mark - Override

- (void)pluginInitialize {
    self.securityConfig = [[NSMutableDictionary alloc] initWithCapacity:20];
    self.lock = [[NSRecursiveLock alloc] init];
}

#pragma mark - Privite
/*
 解析配置表
 */
- (void)pluginSecurityInfomation:(NSArray<NSString *>*)secInfo {
    for (NSString *map in secInfo) {
        NSData *jsonData =  [map dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            return;
        }
        
        if (![json isKindOfClass:[NSArray class]] || [json allObjects].count < 3) {
            return;
        }
        
        NSString *service = [json objectAtIndex:0];
        NSString *action = [json objectAtIndex:1];
        NSString *level = [json objectAtIndex:2];
        
        if (service && action && level) {
            [self.lock lock];
            if (!self.securityConfig[service]) {
                self.securityConfig[service] = [NSMutableArray new];
            }
            
            NSMutableArray *whiteListForService = self.securityConfig[service];
            NSMutableDictionary *whiteListForActions = [NSMutableDictionary new];
            if (action) whiteListForActions[kPluginSecurityActionKey] = [action copy];
            if (level) whiteListForActions[kPluginSecuritylevelKey] = [level copy];
            [whiteListForService addObject:whiteListForActions];
            self.securityConfig[service] = whiteListForService;
            [self.lock unlock];
        }
    }
}

#pragma mark - PHPluginSecurityProtocol

/**
 判断权限
 */
- (void)applyAuthorityWithService:(NSString *)serviceName action:(NSString *)actionName securityInfomation:(nonnull NSArray<NSString *> *)secInfo complete:(PHJudgeAuthorityComplete)completionHandler {
    // 获取到了service、action和安全配置信息，具体怎么处理按照业务逻辑定
    // 获取当前加载的url
    WKWebView *webview = [self.commandDelegate webView];
    NSURL *url = webview.URL;
    NSString *webUri = url.absoluteString;
    NSLog(@"uri : %@",webUri);
    // 获取url权限等级
    // ...
    NSInteger auth = 4;
    
    // 解析
    [self pluginSecurityInfomation:secInfo];
    
    [self.lock lock];
    NSArray *securityConfigForService = [self.securityConfig[serviceName] copy];
    [self.lock unlock];
    NSLog(@"whiteListForService:%@",securityConfigForService);
    
    //service不在配置名单内，默认不允许访问
    if (!securityConfigForService ||
        ![securityConfigForService isKindOfClass:[NSArray class]] ||
        securityConfigForService.count < 1) {
        
        if (completionHandler) completionHandler(NO);
        return ;
    }
    
    BOOL isRegist = NO;
    for (NSDictionary *plugin in securityConfigForService) {
        
        NSString *registerAction = plugin[kPluginSecurityActionKey];
        NSString *registerLevel = plugin[kPluginSecuritylevelKey];
        NSLog(@"%@",plugin);
        if ([registerAction isEqualToString:actionName]) {
            // 注册了看级别，级别越小权限越大
            if (completionHandler) {
                (auth > [registerLevel integerValue]) ? completionHandler(NO) : completionHandler(YES);
            }
            isRegist = YES;
            break;
        }
    }
    // action不在配置名单内，默认不允许访问
    if (!isRegist) {
        if (completionHandler) completionHandler(NO);
    }
}


@end
