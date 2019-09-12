//
//  WKWebViewDelegate.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/6.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@class WKWebViewEngine;
NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewDelegate : NSObject <WKUIDelegate, WKNavigationDelegate>
- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine;
@end

NS_ASSUME_NONNULL_END
