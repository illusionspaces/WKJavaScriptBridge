//
//  WKJavaScriptMessageDispatcher.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class WKJavaScriptBridge;

@interface WKJavaScriptMessageDispatcher : NSObject
- (void)handleMsgCommand:(NSString *)arguments;
- (instancetype)initWithBridge:(WKJavaScriptBridge *)bridge;
@end

NS_ASSUME_NONNULL_END
