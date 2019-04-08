# 简介
### 一个基于WKWebView实现的iOS端JS-Bridge，基于Plugin思想实现了通信插件化和可配置性。
### 详细介绍：https://juejin.im/post/5c07d95ee51d451d930b04c7


# 优势
### 1.插件化，功能组件独立无耦合。
### 2.插件可配置。
### 3.对前端接口统一（待完善）。
### 4.基于WKWebView。
### 5.通信性能优化（待完善）。
### 6.框架内不提供WebView。
### 7.不需要添加工程，引入文件夹即可。



# 使用说明：

## webView绑定，让webView具有hybrid能力：

### 1.是初始化WKWebView的类引入头文件#import "SHRMWebViewEngine.h"。
### 2.初始化SHRMWebViewEngine实例并进行绑定

```
#import "SHRMWebViewEngine.h"

SHRMWebViewEngine *jsBridge = [[SHRMWebViewEngine alloc] init];
jsBridge.delegate = self;
[jsBridge bindBridgeWithWebView:self.webView];
```


# 插件配置

### 1.插件需要引入model层头文件#import "SHRMMsgCommand.h"
### 2.插件接口需要有SHRMMsgCommand类型的形参
### 3.插件类里面添加@SHRMRegisterWebPlugin( )宏，用于插件是否需要预初始化，也可以扩充一些其他功能。

```
@interface SHRMFetchPlugin : NSObject
- (void)nativeFentch:(SHRMMsgCommand *)command;
@end

```

```
#import "SHRMFetchPlugin.h"

@SHRMRegisterWebPlugin(SHRMFetchPlugin, 0)

@implementation SHRMFetchPlugin
- (void)nativeFentch:(SHRMMsgCommand *)command {
NSString *method = [command argumentAtIndex:0];
NSString *url = [command argumentAtIndex:1];
NSString *param = [command argumentAtIndex:2];
NSLog(@"(%@):%@,%@,%@",command.callbackId, method, url, param);
[command.delegate sendPluginResult:@"fetch success" callbackId:command.callbackId];
}

@end
```
___________________________________________________________________________________________________

## JS调用详见index.html文件
```
function ioClick() {
          window.webkit.messageHandlers.SHRMWKJSBridge.postMessage(['13383446','SHRMIOPlugin','nativeIO',['post','openFile','user']]);
            }
```

