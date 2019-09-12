//
//  WKMsgCommand.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKWebPluginAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface WKMsgCommand : NSObject
@property (nonatomic, readonly) NSDictionary *arguments;
@property (nonatomic, readonly) NSString *callbackId;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *methodName;
+ (WKMsgCommand *)commandFromJson:(NSDictionary *)jsonEntry;
@end

NS_ASSUME_NONNULL_END

