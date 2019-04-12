# 简介
### 一个基于WKWebView实现的iOS端JS-Bridge，基于Plugin思想实现了通信插件化和可配置性，每一个js到native的交互都定义为一个插件，依托于框架的管理独立可插拔。当新增一个js与原生交互需求的时候只需要添加一个插件即可。详细思想参考Cordova框架。
### 框架详细介绍戳这里：https://juejin.im/post/5c07d95ee51d451d930b04c7


# 优势
### 1.插件化，功能组件独立无耦合。
### 2.插件可配置，一个宏定义解决插件配置问题。
### 3.对前端接口统一（待完善）。
### 4.基于高性能的WKWebView。
### 5.通信性能优化（待完善）。
### 6.框架内不提供WebView。
### 7.Cookie丢失处理。
### 8.两行代码拥有hybrid能力。



# 使用说明：

## WebView绑定，让WebView具有Hybrid能力：

### 1.是初始化WKWebView的类引入头文件#import "SHRMWebViewEngine.h"。
### 2.初始化SHRMWebViewEngine实例并进行绑定

```
#import "SHRMWebViewEngine.h"

_bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
    [_bridge setWebViewDelegate:self];
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

# JS调用详见index.html文件
```
function ioClick() {
          window.webkit.messageHandlers.SHRMWKJSBridge.postMessage(['13383446','SHRMIOPlugin','nativeIO',['post','openFile','user']]);
            }
```

