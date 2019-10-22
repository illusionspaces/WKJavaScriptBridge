//
//  NSString+BridgeJSONPrivate.m
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "NSString+BridgeJSONPrivate.h"

@implementation NSString (BridgeJSONPrivate)

- (id)bridge_JSONObject {
    @autoreleasepool {
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        
        if (error != nil) {
            NSLog(@"NSString JSONObject error: %@, Malformed Data: %@", [error localizedDescription], self);
        }
        return object;
    }
}

- (id)bridge_JSONFragment {
    @autoreleasepool {
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
        
        if (error != nil) {
            NSLog(@"NSString JSONObject error: %@", [error localizedDescription]);
        }
        return object;
    }
}

@end
