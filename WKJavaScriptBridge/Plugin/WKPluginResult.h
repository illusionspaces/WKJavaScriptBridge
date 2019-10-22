//
//  WKPluginResult.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WKJavaScriptBridgeCommandStatus) {
    WKJavaScriptBridgeCommandStatus_NO_RESULT = 0,
    WKJavaScriptBridgeCommandStatus_ERROR = 1,
    WKJavaScriptBridgeCommandStatus_OK = 2
};

@interface WKPluginResult : NSObject

@property (nonatomic, strong, readonly) NSNumber* status;
@property (nonatomic, strong, readonly) id message;

+ (WKPluginResult*)resultWithStatus:(WKJavaScriptBridgeCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;

+ (WKPluginResult *)resultWithStatus:(WKJavaScriptBridgeCommandStatus)statusOrdinal messageAsString:(NSString *)theMessage;

+ (NSString *)jsSerializeWithJson:(NSDictionary * _Nullable)json;

@end

NS_ASSUME_NONNULL_END
