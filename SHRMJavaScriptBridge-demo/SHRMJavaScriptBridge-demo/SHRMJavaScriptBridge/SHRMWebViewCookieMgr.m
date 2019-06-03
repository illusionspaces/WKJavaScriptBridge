//
//  SHRMWebViewCookieMgr.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/4.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMWebViewCookieMgr.h"

@implementation SHRMWebViewCookieMgr

+ (void)syncRequestCookie:(NSMutableURLRequest *)request {
    if (!request.URL) {
        return;
    }
    
    NSArray *availableCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    if (availableCookie.count > 0) {
        NSDictionary *reqheader = [NSHTTPCookie requestHeaderFieldsWithCookies:availableCookie];
        NSString *cookieStr = [reqheader objectForKey:@"Cookie"];
        [request setValue:cookieStr forHTTPHeaderField:@"Cookie"];
    }
    return;
}

+ (NSString *)clientCookieScripts {
    NSArray *availableCookie = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
    NSMutableArray *filterCookie = [[NSMutableArray alloc]init];
    for (NSHTTPCookie * cookie in availableCookie) {
        if (!cookie.HTTPOnly) {
            [filterCookie addObject:cookie];
        }
    }
    
    if (filterCookie.count > 0) {
        for (NSHTTPCookie *cookie in filterCookie) {
            NSTimeInterval expiretime = [cookie.expiresDate timeIntervalSince1970];
            NSString *js = [NSString stringWithFormat:@"document.cookie ='%@=%@;expires=%f';",cookie.name,cookie.value,expiretime];
            return js;
        }
    }
    return nil;
}

+ (NSMutableURLRequest *)newRequest:(NSURLRequest *)request {
    NSMutableURLRequest *newReq = [request mutableCopy];
    NSMutableArray *array = [NSMutableArray array];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL]) {
        NSString *value = [NSString stringWithFormat:@"%@=%@", cookie.name, cookie.value];
        [array addObject:value];
    }
    
    NSString *cookie = [array componentsJoinedByString:@";"];
    [newReq setValue:cookie forHTTPHeaderField:@"Cookie"];
    return newReq;
}
@end
