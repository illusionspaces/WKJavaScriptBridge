//
//  WKMsgCommand.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "WKMsgCommand.h"

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
    
    id tmp = [jsonEntry objectForKey:@"id"];
    NSString *callbackId = tmp == [NSNull null] ? nil : tmp;
    NSString *className = [jsonEntry objectForKey:@"service"];
    NSString *methodName = [jsonEntry objectForKey:@"action"];
    NSDictionary *arguments = [jsonEntry objectForKey:@"actionArgs"];
    
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
