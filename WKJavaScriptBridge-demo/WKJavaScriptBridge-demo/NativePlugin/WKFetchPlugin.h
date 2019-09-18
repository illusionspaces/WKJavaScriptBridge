//
//  WKFetchPlugin.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKBasePlugin.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKFetchPlugin : WKBasePlugin
- (void)nativePost:(WKMsgCommand *)command;
- (void)nativeGet:(WKMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END
