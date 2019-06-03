//
//  SHRMUIWebViewBridgeProtocol.h
//  SHRMJavaScriptBridge-demo
//
//  Created by Kevin on 2019/6/3.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRMWebViewEngine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SHRMUIWebViewBridgeProtocol <NSObject, UIWebViewDelegate>
@property (nonatomic, weak) NSObject<UIWebViewDelegate> *UIWebViewDelegateCalss;
- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine;
@end

NS_ASSUME_NONNULL_END
