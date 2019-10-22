//
//  PlusShare.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/9/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlusShare : WKBasePlugin
- (void)getServices:(WKMsgCommand *)command;
- (void)sendWithSystem:(WKMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END
