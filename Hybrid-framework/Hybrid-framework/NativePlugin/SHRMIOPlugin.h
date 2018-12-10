//
//  SHRMIOPlugin.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/8.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMMsgCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRMIOPlugin : NSObject
- (void)nativeIO:(SHRMMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END

