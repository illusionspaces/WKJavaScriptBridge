//
//  SHRMWebViewProtocol.h
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHRMWebViewProtocol <NSObject>

/**
native 调用 js 接口

 @param result simulate data
 @param callbackId callbackId
 */
- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId;

/**
封装个子线程接口

 @param block long running
 */
- (void)runInBackground:(void (^)(void))block;

/**
 webView controller
 */
@property (nonatomic, strong) UIViewController *rootViewController;

@end

NS_ASSUME_NONNULL_END
