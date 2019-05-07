//
//  SHRMPushDemoPlugin.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/8.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMBasePlugin.h"
NS_ASSUME_NONNULL_BEGIN

@interface SHRMPushDemoPlugin : SHRMBasePlugin
- (void)pushTestVC:(SHRMMsgCommand *)command;
@end

NS_ASSUME_NONNULL_END
