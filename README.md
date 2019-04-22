# 简介
### 兼容WKWebView和UIWebView
### WKWebView通信：addScriptMessageHandler
### UIWebView通信：JavaScriptCore
### 框架详细介绍戳这里：https://juejin.im/post/5c07d95ee51d451d930b04c7


# 功能
### 1.兼容WKWebView和UIWebView。
### 2.插件化JS-Native业务逻辑。
### 3.基于__attribute函数进行插件注册。
### 4.针对WKWebView进行了Cookie丢失处理。
### 5.支持Native-JS的统一回调处理。


# 使用说明：
## WebView绑定，让WebView具有Hybrid能力：
```
#import "SHRMWebViewEngine.h"
@interface TestUIWebViewController ()
@property (nonatomic, strong) SHRMWebViewEngine* bridge;
@end

/*
webView:UIWebView or WKWebView instance
*/
_bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
[_bridge setWebViewDelegate:self];
```


## 自定义业务插件（当有了一个新的需求或者JS-Native的交互需要将其定义为插件，例如JS端想获取当前定位，或者JS端想获取设备信息等等）

### 1.创建插件类，继承自SHRMBasePlugin。
### 2.插件类里面添加@SHRMRegisterWebPlugin宏，暂时用于插件是否需要提前初始化，加快第一次调用速度。也可以扩充一些其他功能。

```
#import "SHRMBasePlugin.h"
@interface SHRMTestUIWebViewPlguin : SHRMBasePlugin
- (void)nativeTestUIWebView:(SHRMMsgCommand *)command;
@end

```

```
@SHRMRegisterWebPlugin(SHRMTestUIWebViewPlguin, 1)

@implementation SHRMTestUIWebViewPlguin
- (void)nativeTestUIWebView:(SHRMMsgCommand *)command {
    NSString *method = [command argumentAtIndex:0];
    NSString *url = [command argumentAtIndex:1];
    NSString *param = [command argumentAtIndex:2];
    NSLog(@"(%@):%@,%@,%@",command.callbackId, method, url, param);
    [self.commandDelegate sendPluginResult:@"uiwebview test success!" callbackId:command.callbackId];
}
@end
```

# JS调用详见index.html文件

