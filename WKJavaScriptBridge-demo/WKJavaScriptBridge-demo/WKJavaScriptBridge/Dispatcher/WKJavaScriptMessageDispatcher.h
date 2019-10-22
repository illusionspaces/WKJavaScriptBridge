//
//  WKJavaScriptMessageDispatcher.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKJavaScriptBridgeEngine;

@interface WKJavaScriptMessageDispatcher : NSObject
- (void)handleMsgCommand:(NSString *)arguments;
- (instancetype)initWithWebViewEngine:(WKJavaScriptBridgeEngine *)webViewEngine;
@end

NS_ASSUME_NONNULL_END
