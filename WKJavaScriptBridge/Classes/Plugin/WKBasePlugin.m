//
//  WKBasePlugin.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKBasePlugin.h"

@implementation WKBasePlugin

#pragma mark - Override

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppTerminate) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)pluginInitialize {
    
}

- (void)onAppTerminate {
    
}

- (void)onMemoryWarning {
    
}

- (void)dispose {
    
}

#pragma mark - WKPluginProtocol

+ (BOOL)shouldCache {
    return YES;
}

@end
