//
//  SHRMPluginResult.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/23.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMPluginResult.h"

@interface SHRMPluginResult ()

@property (nonatomic, strong, readwrite) NSNumber* status;
@property (nonatomic, strong, readwrite) id message;

@end

@implementation SHRMPluginResult

+ (SHRMPluginResult *)resultWithStatus:(SHRMCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary *)theMessage {
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (SHRMPluginResult *)resultWithStatus:(SHRMCommandStatus)statusOrdinal messageAsString:(NSString *)theMessage {
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

- (SHRMPluginResult*)initWithStatus:(SHRMCommandStatus)statusOrdinal message:(id)theMessage {
    self = [super init];
    if (self) {
        self.status = [NSNumber numberWithInt:statusOrdinal];
        self.message = theMessage;
    }
    return self;
}

- (NSString*)argumentsAsJSON
{
    id arguments = (self.message == nil ? [NSNull null] : self.message);
    NSArray* argumentsWrappedInArray = [NSArray arrayWithObject:arguments];
    
    NSString* argumentsJSON = [self JSONString:argumentsWrappedInArray];
    
    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];
    return argumentsJSON;
}

- (NSString*)JSONString:(NSArray *)array {
    @autoreleasepool {
        NSError* error = nil;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                           options:0
                                                             error:&error];
        
        if (error != nil) {
            NSLog(@"NSArray JSONString error: %@", [error localizedDescription]);
            return nil;
        } else {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
}

@end
