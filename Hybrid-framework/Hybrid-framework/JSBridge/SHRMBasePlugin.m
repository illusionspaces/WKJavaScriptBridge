//
//  SHRMBasePlugin.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMBasePlugin.h"
#import "SHRMWebViewEngine.h"

@implementation SHRMBasePlugin

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (UIViewController *)rootViewController {
    if (_webViewEngine != nil) {
        return self.webViewEngine.webViewDelegate;
    }
    return nil;
}

- (void)pluginInitialize {
    
}

- (void)onAppTerminate {
    
}

- (void)onMemoryWarning {
    
}

- (void)onReset {
    
}

- (void)dispose {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
