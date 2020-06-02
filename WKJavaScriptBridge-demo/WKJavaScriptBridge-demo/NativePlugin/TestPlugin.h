//
//  TestPlugin.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2020/6/2.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestPlugin : WKBasePlugin

- (void)testSecurity:(WKMsgCommand *)command;

@end

NS_ASSUME_NONNULL_END
