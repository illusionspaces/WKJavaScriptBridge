# Hybrid-ios
A hybrid framework for iOS.

## 使用说明：

## WebView

### 1.引入头文件 #import "SHRMWebViewEngine.h"
### 2.需要绑定webView

SHRMWebViewEngine *jsBridge = [[SHRMWebViewEngine alloc] init];

jsBridge.delegate = self;

[jsBridge bindBridgeWithWebView:self.webView];

## 插件

### 1.插件需要引入model层头文件#import "SHRMMsgCommand.h"
### 2.插件接口需要有SHRMMsgCommand类型的形参
### 3.插件类里面添加@SHRMRegisterWebPlugin( )宏

## JS调用详见index.html文件

### JS接口还未封装，后续会封装一下
