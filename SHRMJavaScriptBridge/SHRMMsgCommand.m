//
//  SHRMMsgCommand.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/7.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMMsgCommand.h"

@interface SHRMMsgCommand ()
@property (nonatomic, readwrite) NSArray* arguments;
@property (nonatomic, readwrite) NSString* callbackId;
@property (nonatomic, readwrite) NSString* className;
@property (nonatomic, readwrite) NSString* methodName;
@end

@implementation SHRMMsgCommand
+ (SHRMMsgCommand *)commandFromJson:(NSArray*)jsonEntry {
    return [[SHRMMsgCommand alloc] initFromJson:jsonEntry];
}

- (id)initFromJson:(NSArray*)jsonEntry {
    id tmp = [jsonEntry objectAtIndex:0];
    NSString* callbackId = tmp == [NSNull null] ? nil : tmp;
    NSString* className = [jsonEntry objectAtIndex:1];
    NSString* methodName = [jsonEntry objectAtIndex:2];
    NSMutableArray* arguments = [jsonEntry objectAtIndex:3];
    
    return [self initWithArguments:arguments
                        callbackId:callbackId
                         className:className
                        methodName:methodName];
}

- (id)initWithArguments:(NSArray*)arguments
             callbackId:(NSString*)callbackId
              className:(NSString*)className
             methodName:(NSString*)methodName {
    self = [super init];
    if (self != nil) {
        _arguments = arguments;
        _callbackId = callbackId;
        _className = className;
        _methodName = methodName;
    }
    return self;
}

- (id)argumentAtIndex:(NSUInteger)index {
    if (index >= [_arguments count]) {
        return nil;
    }
    id argument = [_arguments objectAtIndex:index];
    if (argument == [NSNull null]) {
        argument = nil;
    }
    return argument;
}

@end
