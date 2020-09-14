//
//  WKCommonPlugin.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKCommonPlugin : WKBasePlugin

- (void)asynDisplayCommon:(WKMsgCommand *)command;

- (void)asyncTestSecurity:(WKMsgCommand *)command;

@end

NS_ASSUME_NONNULL_END
