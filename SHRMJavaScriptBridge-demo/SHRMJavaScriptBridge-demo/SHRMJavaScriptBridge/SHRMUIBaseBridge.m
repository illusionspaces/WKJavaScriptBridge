//
//  SHRMUIBaseBridge.m
//  SHRMJavaScriptBridge-demo
//
//  Created by Kevin on 2019/6/3.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMUIBaseBridge.h"

@interface SHRMUIBaseBridge ()
@property (nonatomic, strong) SHRMWebViewEngine *webViewEngine;
@end

@implementation SHRMUIBaseBridge

@synthesize UIWebViewDelegateCalss;

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.UIWebViewDelegateCalss webViewDidStartLoad:webView];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.UIWebViewDelegateCalss webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.UIWebViewDelegateCalss webView:webView didFailLoadWithError:error];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    if ([[url scheme] isEqualToString:@"protocol"]) {
        NSString *decodedURL = request.URL.absoluteString.stringByRemovingPercentEncoding;
        NSArray *paramArray = [decodedURL componentsSeparatedByString:@"#"];
        NSString * command = [paramArray lastObject];
        
        NSError* error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[command dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        if (error != nil) {
            NSLog(@"NSString JSONObject error: %@, Malformed Data: %@", [error localizedDescription], self);
        }
        
        if (self.webViewEngine) {
            [self.webViewEngine.webViewhandleFactory handleMsgCommand:(NSArray *)object];
        }
        
        return NO;
    }
    
    if (self.UIWebViewDelegateCalss && [self.UIWebViewDelegateCalss respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.UIWebViewDelegateCalss webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }else {
        return YES;
    }
}


#pragma mark - SHRMUIWebViewBridgeProtocol

- (void)setWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    _webViewEngine = webViewEngine;
}

- (void)dealloc {
    self.webViewEngine = nil;
}

@end
