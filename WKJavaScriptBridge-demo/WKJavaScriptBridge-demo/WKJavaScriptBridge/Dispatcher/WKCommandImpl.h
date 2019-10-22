//
//  WKCommandImpl.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKCommandProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class WKJavaScriptBridgeEngine;

@interface WKCommandImpl : NSObject<WKCommandProtocol>
- (instancetype)initWithWebViewEngine:(WKJavaScriptBridgeEngine *)webViewEngine;
@end

NS_ASSUME_NONNULL_END
