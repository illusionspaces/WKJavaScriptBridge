//
//  TestSecurityPlugin.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2020/6/2.
//  Copyright © 2020 王凯. All rights reserved.
//

#import "WKBasePlugin.h"
#import "TestWebPluginSecurityConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestSecurityPlugin : WKBasePlugin <WKPluginSecurityProtocol>

@end

NS_ASSUME_NONNULL_END
