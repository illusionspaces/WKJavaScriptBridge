//
//  NSString+BridgeJSONPrivate.h
//  WKJavaScriptBridge-demo
//
//  Created by Kevin on 2019/10/22.
//  Copyright © 2019 王凯. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BridgeJSONPrivate)
- (id)bridge_JSONObject;
- (id)bridge_JSONFragment;
@end

NS_ASSUME_NONNULL_END
