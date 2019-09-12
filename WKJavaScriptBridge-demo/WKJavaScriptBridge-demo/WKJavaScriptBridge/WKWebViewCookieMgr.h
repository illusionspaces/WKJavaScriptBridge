//
//  WKWebViewCookieMgr.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/4.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewCookieMgr : NSObject
+ (void)syncRequestCookie:(NSMutableURLRequest *)request;
+ (NSString *)clientCookieScripts;
+ (NSMutableURLRequest *)newRequest:(NSURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
