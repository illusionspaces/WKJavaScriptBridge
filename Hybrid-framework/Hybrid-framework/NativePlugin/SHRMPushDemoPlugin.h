//
//  SHRMPushDemoPlugin.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/8.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMMsgCommand.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHRMPushDemoPlugin : NSObject
- (void)pushTestVC:(SHRMMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END
