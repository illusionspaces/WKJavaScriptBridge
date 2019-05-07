//
//  SHRMCommandImpl.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMCommandProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class SHRMWebViewEngine;

@interface SHRMCommandImpl : NSObject<SHRMCommandProtocol>
- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine;
@end

NS_ASSUME_NONNULL_END
