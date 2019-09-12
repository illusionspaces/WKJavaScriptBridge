//
//  WKBasePlugin.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WKCommandProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class WKWebViewEngine;

@interface WKBasePlugin : NSObject

@property (nonatomic, weak) id <WKCommandProtocol> commandDelegate;
@property (nonatomic, readonly, weak) UIViewController* rootViewController;

- (instancetype)initWithWebViewEngine:(WKWebViewEngine *)webViewEngine;
- (void)pluginInitialize;
- (void)onAppTerminate;
- (void)onMemoryWarning;
- (void)onReset;
- (void)dispose;

@end

NS_ASSUME_NONNULL_END
