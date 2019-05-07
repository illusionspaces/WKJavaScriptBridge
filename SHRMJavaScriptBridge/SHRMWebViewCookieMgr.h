//
//  SHRMWebViewCookieMgr.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/4.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHRMWebViewCookieMgr : NSObject
+ (void)syncRequestCookie:(NSMutableURLRequest *)request;
+ (NSString *)clientCookieScripts;
+ (void)resetCookie;
@end

NS_ASSUME_NONNULL_END
