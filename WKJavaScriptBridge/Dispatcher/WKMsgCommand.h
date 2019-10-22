//
//  WKMsgCommand.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKJavaScriptBridgePluginAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKMsgCommand : NSObject
@property (nonatomic, readonly) NSDictionary *arguments;
@property (nonatomic, readonly) NSString *callbackId;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *methodName;
+ (WKMsgCommand *)commandFromJson:(NSDictionary *)jsonEntry;
@end

NS_ASSUME_NONNULL_END
