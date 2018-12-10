//
//  SHRMMsgCommand.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMWebViewProtocol.h"
#import "SHRMWebPluginAnnotation.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRMMsgCommand : NSObject
@property (nonatomic, readonly) NSArray* arguments;
@property (nonatomic, readonly) NSString* callbackId;
@property (nonatomic, readonly) NSString* className;
@property (nonatomic, readonly) NSString* methodName;
@property (nonatomic, weak) id <SHRMWebViewProtocol> delegate;
+ (SHRMMsgCommand *)commandFromJson:(NSArray*)jsonEntry;
- (id)argumentAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END

