//
//  WKPluginResult.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/23.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WKCommandStatus) {
    WKCommandStatus_ERROR = 0,
    WKCommandStatus_OK
};

@interface WKPluginResult : NSObject

@property (nonatomic, strong, readonly) NSNumber* status;
@property (nonatomic, strong, readonly) id message;

+ (WKPluginResult*)resultWithStatus:(WKCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;

+ (WKPluginResult *)resultWithStatus:(WKCommandStatus)statusOrdinal messageAsString:(NSString *)theMessage;

+ (NSString *)jsSerializeWithJson:(NSDictionary * _Nullable)json;

@end

NS_ASSUME_NONNULL_END
