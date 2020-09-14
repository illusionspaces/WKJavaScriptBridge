//
//  WKMsgCommand.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKMsgCommand.h"

static const NSString const * kMessageCallbackId = @"callbackId";
static const NSString const * kMessageService = @"service";
static const NSString const * kMessageAction = @"action";
static const NSString const * kMessageActionArgs = @"actionArgs";

@interface WKMsgCommand ()
@property (nonatomic, readwrite) NSDictionary* arguments;
@property (nonatomic, readwrite) NSString* callbackId;
@property (nonatomic, readwrite) NSString* className;
@property (nonatomic, readwrite) NSString* methodName;
@end

@implementation WKMsgCommand

+ (WKMsgCommand *)commandFromJson:(NSDictionary *)jsonEntry {
    return [[WKMsgCommand alloc] initFromJson:jsonEntry];
}

- (id)initFromJson:(NSDictionary *)jsonEntry {
    
    id tmp = [jsonEntry objectForKey:kMessageCallbackId];
    NSString *callbackId = tmp == [NSNull null] ? nil : tmp;
    NSString *className = [jsonEntry objectForKey:kMessageService];
    NSString *methodName = [jsonEntry objectForKey:kMessageAction];
    NSDictionary *arguments = [jsonEntry objectForKey:kMessageActionArgs];
    
    return [self initWithArguments:arguments
                        callbackId:callbackId
                         className:className
                        methodName:methodName];
}

- (id)initWithArguments:(NSDictionary *)arguments
             callbackId:(NSString *)callbackId
              className:(NSString *)className
             methodName:(NSString *)methodName {
    self = [super init];
    if (self != nil) {
        _arguments = arguments;
        _callbackId = callbackId;
        _className = className;
        _methodName = methodName;
    }
    return self;
}

@end
