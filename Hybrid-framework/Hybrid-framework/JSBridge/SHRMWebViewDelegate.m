//
//  SHRMWebViewDelegate.m
//  Hybrid-framework
//
//  Created by 王凯 on 2018/12/6.
//  Copyright © 2018 王凯. All rights reserved.
//

#import "SHRMWebViewDelegate.h"
#import "SHRMWebViewEngine.h"

@implementation SHRMWebViewDelegate {
    __weak SHRMWebViewEngine *_webViewEngine;
    UIProgressView *_progressView;
}

- (instancetype)initWithWebViewEngine:(SHRMWebViewEngine *)webViewEngine {
    if (self = [super init]) {
        _webViewEngine = webViewEngine;
        [self initProgressView];
    }
    return self;
}

- (void)initProgressView {
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    if ([_webViewEngine.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)_webViewEngine.delegate;
        [viewController.view addSubview:progressView];
        _progressView = progressView;
    }
    [_webViewEngine.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]) {
        [_webViewEngine.delegate observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    if (object == _webViewEngine.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [_progressView setProgress:1.0 animated:YES];
            __weak UIProgressView *weakProgressView = _progressView;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakProgressView.hidden = YES;
                [weakProgressView setProgress:0 animated:NO];
            });
            
        }else {
            _progressView.hidden = NO;
            [_progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKUIDelegate

//webView中弹出警告框时调用, 只能有一个按钮
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [_webViewEngine.delegate webView:webView runJavaScriptAlertPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"native call js success" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    
    [alert addAction:ok];
    if ([_webViewEngine.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)_webViewEngine.delegate;
        [viewController presentViewController:alert animated:YES completion:nil];
    }
}

// webView中弹出选择框时调用, 两个按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)]) {
        [_webViewEngine.delegate webView:webView runJavaScriptConfirmPanelWithMessage:message initiatedByFrame:frame completionHandler:completionHandler];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    if ([_webViewEngine.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)_webViewEngine.delegate;
        [viewController presentViewController:alert animated:YES completion:nil];
    }
    
}

//对应js的prompt方法 completionHandler 输入框消失的时候调用, 回调给JS, 参数为输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入" message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入";
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = [alert.textFields firstObject];
        
        completionHandler(tf.text);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(defaultText);
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    if ([_webViewEngine.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController *)_webViewEngine.delegate;
        [viewController presentViewController:alert animated:YES completion:nil];
    }
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)]) {
        [_webViewEngine.delegate webView:webView runJavaScriptTextInputPanelWithPrompt:prompt defaultText:defaultText initiatedByFrame:frame completionHandler:completionHandler];
    }
}


#pragma mark - WKNavigationDelegate

// 决定导航的动作，通常用于处理跨域的链接能否导航。
// WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接单独处理。
// 但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    //  在发送请求之前，决定是否跳转
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)]) {
        [_webViewEngine.delegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 是否接收响应
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    // 在收到响应后，决定是否跳转和发送请求之前那个允许配套使用
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:decidePolicyForNavigationResponse:decisionHandler:)]) {
        [_webViewEngine.delegate webView:webView decidePolicyForNavigationResponse:navigationResponse decisionHandler:decisionHandler];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//用于授权验证的API，与AFN、UIWebView的授权验证API是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler{
    
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didReceiveAuthenticationChallenge:completionHandler:)]) {
        [_webViewEngine.delegate webView:webView didReceiveAuthenticationChallenge:challenge completionHandler:completionHandler];
    }
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling ,nil);
}

// main frame的导航开始请求时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didStartProvisionalNavigation:)]) {
        [_webViewEngine.delegate webView:webView didStartProvisionalNavigation:navigation];
    }
}

// 当main frame接收到服务重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    // 接收到服务器跳转请求之后调用
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didReceiveServerRedirectForProvisionalNavigation:)]) {
        [_webViewEngine.delegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
    }
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [_webViewEngine.delegate webView:webView didFailProvisionalNavigation:navigation withError:error];
    }
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [_webViewEngine.delegate webView:webView didCommitNavigation:navigation];
    }
}

//当main frame导航完成时，会回调
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    // 页面加载完成之后调用
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didFinishNavigation:)]) {
        [_webViewEngine.delegate webView:webView didFinishNavigation:navigation];
    }
}

// 当main frame最后下载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
        [_webViewEngine.delegate webView:webView didFailNavigation:navigation withError:error];
    }
}

// 当web content处理完成时，会回调
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    if (_webViewEngine.delegate && [_webViewEngine.delegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate:)]) {
        if (@available(iOS 9.0, *)) {
            [_webViewEngine.delegate webViewWebContentProcessDidTerminate:webView];
        } else {
            // Fallback on earlier versions
        }
    }
}

@end
