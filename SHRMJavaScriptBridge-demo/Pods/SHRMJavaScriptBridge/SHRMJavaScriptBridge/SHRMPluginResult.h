//
//  SHRMPluginResult.h
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/23.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SHRMCommandStatus) {
    SHRMCommandStatus_OK = 0,
    SHRMCommandStatus_ERROR
};

@interface SHRMPluginResult : NSObject

@property (nonatomic, strong, readonly) NSNumber* status;
@property (nonatomic, strong, readonly) id message;

+ (SHRMPluginResult*)resultWithStatus:(SHRMCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary*)theMessage;

+ (SHRMPluginResult *)resultWithStatus:(SHRMCommandStatus)statusOrdinal messageAsString:(NSString *)theMessage;

- (NSString*)argumentsAsJSON;

@end

NS_ASSUME_NONNULL_END
