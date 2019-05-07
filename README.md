# Link
* Blog : [写一个易于维护使用方便性能可靠的Hybrid框架](https://juejin.im/post/5c07d95ee51d451d930b04c7)

* [介绍](#中文介绍)

## 介绍

**iOS JS-Native交互框架（支持WKWebView/UIWebView），功能强大，轻松集成，两行代码即可，业务框架分离，易于拓展。**
**关于通信方案说明：**
* WKWebView使用addScritMessageHandler构建通信，苹果提供的bridge，可以理解为亲儿子，好处自然不用多说。
* UIWebView使用JavaScriptCore框架构建通信，JavaScriptCore的黑魔法，连RN都没能逃过，功能可见一斑。


## 特性
- 支持WKWebView和UIWebView，两行代码即可让webView能力无限。
- 针对WKWebView进行了Cookie丢失处理。
- 插件化JS-Native业务逻辑，业务完全分离，解耦。
- 基于__attribute( )函数进行插件注册，业务模块的注册只需要在自己内部注册即可，摆脱plist等传统注册方式。目前已知[阿里BeeHive](https://github.com/alibaba/BeeHive)/[美团Kylin组件](https://juejin.im/post/5c0a17d6e51d4570cf60d102)皆使用此方式进行注册。
- 业务模块回调参数给JS侧进行了统一回调处理：业务模块完全不关心是WK or UI。


## 安装

### 1.手动导入

下载SHRMJavaScriptBridge文件夹，将SHRMJavaScriptBridge文件夹拖入到你的工程中。

### 2.CocoaPods
1. 在 Podfile 中添加 `pod 'SHRMJavaScriptBridge'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `<SHRMWebViewEngine.h>`。


## 用法
`SHRMWebViewEngine`是框架的主体类，对外提供两个函数：`bindBridgeWithWebView:`传入你的webView，`setWebViewDelegate:`传入你的controller，用来拦截webView的代理函数。具体参照demo。

### 1.使用框架

```objc
// WKWebView
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
WKPreferences *preferences = [WKPreferences new];
preferences.javaScriptCanOpenWindowsAutomatically = YES;
preferences.minimumFontSize = 40.0;
configuration.preferences = preferences;
WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
webView.navigationDelegate = self;
/***/
SHRMWebViewEngine* bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
[bridge setWebViewDelegate:self];
/***/
[self.view addSubview:webView];
NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
if (@available(iOS 9.0, *)) {
[webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
} else {
// Fallback on earlier versions
}
```

```objc
// UIWebView
UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
/***/
SHRMWebViewEngine* bridge = [SHRMWebViewEngine bindBridgeWithWebView:webView];
[bridge setWebViewDelegate:self];
/***/
[self.view addSubview:webView];
NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index1.html" ofType:nil];
NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
[webView loadRequest:[NSURLRequest requestWithURL:fileURL]];
```
两种WebView在使用上并无差别，完全兼容。具体的请下载Demo进行查看。

### 2.自定义业务插件（原生侧）

1. 创建插件类，继承自`SHRMBasePlugin`。
2. 插件类里面添加`@SHRMRegisterWebPlugin`宏，暂时用于插件是否需要提前初始化，加快第一次调用速度。也可以扩充一些其他功能。
3. 插件里构建业务逻辑，通过`sendPluginResult:callbackId:`函数把结果回传给JS侧。

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

SHRMPluginResult *result = [SHRMPluginResult resultWithStatus:SHRMCommandStatus_OK messageAsString:@"uiwebview test success!"];
[self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
@end
```

这样一个插件就定义完毕了：插件的意思就是独立的，与其他功能模块无耦合的业务模块，用来处理一类JS-Native的交互。例如JS想要获取地图信息、wifi信息、文件处理等都可以定义为一个插件。插件的好处就是无耦合！！！拖入项目可以直接使用，删除后项目也不需要做任何修改，直接build！以后再有新的交互需求你只需要按照上面的步骤创建插件完成功能并把结果返回给JS就可以了！不需要动框架！！

### 3.自定义业务插件（JS侧）

JS侧目前还没有开放插件化功能，只是说还不够完善，但它不影响功能使用：
1. 如果JS加载在WKWebView，JS调用Native通过`window.webkit.messageHandlers.SHRMWKJSBridge.postMessage(['13383445','SHRMFetchPlugin','nativeFentch',['post','https:www.baidu.com','user']])`即可，`['post','https:www.baidu.com','user']`为想要传递的参数。`13383445`为此次通信ID，`SHRMFetchPlugin`为Native侧插件类名，`nativeFentch`为插件方法名。
2. 如果JS加载在UIWebView，JS调用Native通过`postUIWebViewParamer(['13383446','SHRMTestUIWebViewPlguin','nativeTestUIWebView',['post','openFile','user']])`即可，其中`['post','openFile','user']`依旧为你想要传递的参数，另外三个参数含义同上。
3. 详细使用参照Demo。

## 后续功能延伸：

1. JS侧插件化。
2. 基于此引入离线包。
3. 引入flutter构建小程序。
4. other  ...

## License

SHRMJavaScriptBridge is available under the Apache License 2.0. See the LICENSE file for more info.

