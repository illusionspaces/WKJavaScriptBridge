//
//  SHRMCommandImpl.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/20.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMCommandImpl.h"
#import "SHRMWebViewEngine.h"

@implementation SHRMCommandImpl {
    __weak SHRMWebViewEngine *_webViewEngine;
}

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
    }
    return self;
}

- (void)sendPluginResult:(NSString *)result callbackId:(NSString*)callbackId {
    [_webViewEngine.bridge sendPluginResult:result callbackId:callbackId];
}

- (id)getCommandInstance:(NSString*)pluginName {
    return [_webViewEngine getCommandInstance:pluginName];
}

- (void)runInBackground:(void (^)(void))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

@end
