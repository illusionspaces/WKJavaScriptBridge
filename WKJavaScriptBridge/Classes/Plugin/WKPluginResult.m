//
//  WKPluginResult.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "WKPluginResult.h"

@interface WKPluginResult ()

@property (nonatomic, strong, readwrite) NSNumber* status;
@property (nonatomic, strong, readwrite) id message;

@end

@implementation WKPluginResult

+ (WKPluginResult *)resultWithStatus:(WKJavaScriptBridgeCommandStatus)statusOrdinal messageAsDictionary:(NSDictionary *)theMessage {
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

+ (WKPluginResult *)resultWithStatus:(WKJavaScriptBridgeCommandStatus)statusOrdinal messageAsString:(NSString *)theMessage {
    return [[self alloc] initWithStatus:statusOrdinal message:theMessage];
}

- (WKPluginResult*)initWithStatus:(WKJavaScriptBridgeCommandStatus)statusOrdinal message:(id)theMessage {
    self = [super init];
    if (self) {
        self.status = [NSNumber numberWithInt:statusOrdinal];
        self.message = theMessage;
    }
    return self;
}

+ (NSString *)jsSerializeWithJson:(NSDictionary * _Nullable)json {
    NSString *messageJSON = [self serializeWithJson:json ? json : @{} pretty:NO];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    return messageJSON;
}

+ (NSString *)serializeWithJson:(NSDictionary * _Nullable)json pretty:(BOOL)pretty {
    NSError *error = nil;
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:json ? json : @{} options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:&error] encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    if (error) {
        NSLog(@"WKJSBridge Error: format json error %@", error.localizedDescription);
    }
#endif
    
    return str ? str : @"";
}

@end

