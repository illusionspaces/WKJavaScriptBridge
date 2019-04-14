//
//  SHRMUIWebViewJavaScriptBridge.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/14.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#import "SHRMWebViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRMUIWebViewJavaScriptBridge : NSObject <UIWebViewDelegate, SHRMWebViewProtocol>
+ (instancetype)bindBridgeWithWebView:(UIWebView *)webView;
/**
 webView容器
 */
@property (nonatomic, weak) id webViewDelegate;
@end

NS_ASSUME_NONNULL_END
