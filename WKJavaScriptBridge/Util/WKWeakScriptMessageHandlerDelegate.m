//
//  WKWeakScriptMessageHandlerDelegate.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKWeakScriptMessageHandlerDelegate.h"

@interface WKWeakScriptMessageHandlerDelegate ()

@property (nonatomic, weak, readwrite) id<WKScriptMessageHandler> scriptDelegate;

@end

@implementation WKWeakScriptMessageHandlerDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

@end
