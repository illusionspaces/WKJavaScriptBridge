//
//  SHRMWebViewEngine.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/5.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "SHRMWebViewProtocol.h"
#import "SHRMWebPluginAnnotation.h"
#import "SHRMWebViewCookieMgr.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRMWebViewEngine : NSObject<WKScriptMessageHandler, SHRMWebViewProtocol>
- (void)bindBridgeWithWebView:(WKWebView *)webView;
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, weak) id delegate;
- (id)getCommandInstance:(NSString*)pluginName;
@end

NS_ASSUME_NONNULL_END
