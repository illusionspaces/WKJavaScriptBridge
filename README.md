# WKJavaScriptBridge


[![Version](https://img.shields.io/cocoapods/v/WKJavaScriptBridge.svg?style=flat)](http://cocoapods.org/pods/WKJavaScriptBridge)
[![Pod License](http://img.shields.io/cocoapods/l/WKJavaScriptBridge.svg?style=flat)](https://opensource.org/licenses/Apache-2.0)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)
![](https://img.shields.io/badge/language-objc-orange.svg)
![ARC](https://img.shields.io/badge/ARC-orange.svg)

## 版本说明：
### 1.release 0.0.6：由于苹果近期给开发者邮件说明，要求尽快删除UIWebView等相关API，因此新增release 0.0.6版本，删除UIWebView的支持。
### 2.release 0.1.0：增加WKJSBridge.js，对JS侧接口做了完善，统一入口，提供参数传递，成功、失败回调。


## Link
* Blog : 

[《写一个易于维护使用方便性能可靠的Hybrid框架（四）—— 框架构建》](https://juejin.im/post/5cd2c6a2f265da037516ba1c)

[《写一个易于维护使用方便性能可靠的Hybrid框架（三）—— 配置插件》](https://juejin.im/post/5c0ca4bde51d4541284cab56)

[《写一个易于维护使用方便性能可靠的Hybrid框架（二）—— 插件化》](https://juejin.im/post/5c0a41e5f265da61335664ba)

[《写一个易于维护使用方便性能可靠的Hybrid框架（一）—— 思路构建》](https://juejin.im/post/5c07d95ee51d451d930b04c7)


## 介绍

**iOS 基于WKWebView的JS-Native交互框架，功能强大，轻松集成，一行代码即可，业务框架分离，易于拓展。**
**关于通信方案说明：**
* WKWebView使用addScritMessageHandler构建通信，苹果提供的bridge，可以理解为亲儿子，好处自然不用多说。

**架构图**

![image text](https://github.com/GitWangKai/WKJavaScriptBridge/blob/master/img.jpg)


**类图**

![image text](https://github.com/GitWangKai/WKJavaScriptBridge/blob/master/img_1.jpg)

## 特性
- 一行代码即可让WebView能力无限。
- 针对WKWebView进行了Cookie丢失处理。
- 针对WKWebView白框架屏问题进行了处理。
- 针对WKWebView所带来的一些Crash问题进行了容错处理。
- 插件化JS-Native业务逻辑，业务完全分离，解耦。
- 不提供WebView&Controller，支持在不影响原业务的情况下，插件化集成。
- 基于__attribute( )函数进行插件注册，业务模块的注册只需要在自己内部注册即可，摆脱plist等传统注册方式。目前已知[阿里BeeHive](https://github.com/alibaba/BeeHive)/[美团Kylin组件](https://juejin.im/post/5c0a17d6e51d4570cf60d102)皆使用此方式进行注册。目前注册功能为插件是否提前预加载提供。
- 业务模块回调参框架数给JS侧进行了统一回调处理。



## 安装

### 1.手动导入

下载WKJavaScriptBridge文件夹，将WKJavaScriptBridge文件夹拖入到你的工程中。

### 2.CocoaPods
1. 在 Podfile 中添加 `pod 'WKJavaScriptBridge', '~> 0.1.0'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 `<WKWebViewEngine.h>`。


## 用法
`WKWebViewEngine`是框架的主体类，对外提供`bindBridgeWithWebView:withDelegate:`接口，用来拦截webView的代理函数。具体参照demo。

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
[WKWebViewEngine bindBridgeWithWebView:webView withDelegate:self];
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

### 2.一些针对WKWebView带来的Crash问题处理
2.1 由于WKWebView在请求过程中用户可能退出界面销毁对象，当请求回调时由于接收处理对象不存在，造成Bad Access crash，所以可将WKProcessPool设为单例
```objc
static WKProcessPool *_sharedWKProcessPoolInstance = nil;
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
    _sharedWKProcessPoolInstance = [[WKProcessPool alloc] init];
});
self.processPool = _sharedWKProcessPoolInstance;

WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
configuration.processPool = self.processPool;
```

2.2 解决window.alert() 时 completionHandler 没有被调用导致崩溃问题

```objc
@property (nonatomic, assign, getter=loadFinished) BOOL isLoadFinished;
```
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLoadFinished = NO;
}
```
```objc
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isLoadFinished = YES;
}
```
```objc
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    if (!self.isLoadFinished) {
        completionHandler();
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { completionHandler(); }]];
    if (self)
        [self presentViewController:alertController animated:YES completion:^{}];
    else
        completionHandler();
}
```


### 4.自定义业务插件（原生侧）

1. 创建插件类，继承自`WKBasePlugin`。
2. 插件类里面添加`@WKRegisterWebPlugin`宏，暂时用于插件是否需要提前初始化，加快第一次调用速度。也可以扩充一些其他功能。
3. 插件里构建业务逻辑，通过`sendPluginResult:callbackId:`函数把结果回传给JS侧。

```objc
#import "WKBasePlugin.h"
@interface WKFetchPlugin : WKBasePlugin
- (void)nativeFentch:(WKMsgCommand *)command;
@end

```

```objc
@WKRegisterWebPlugin(WKFetchPlugin)

@implementation WKFetchPlugin
- (void)nativeFentch:(WKMsgCommand *)command {
    NSString *method = [command.arguments objectForKey:@"method"];
    NSString *url = [command.arguments objectForKey:@"url"];
    
    NSLog(@"method : %@ ; url : %@", method, url);
    
    WKPluginResult *result = [WKPluginResult resultWithStatus:WKCommandStatus_ERROR messageAsDictionary:@{@"result": @"success!!"}];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
```

这样一个插件就定义完毕了：插件的意思就是独立的，与其他功能模块无耦合的业务模块，用来处理一类JS-Native的交互。例如JS想要获取地图信息、wifi信息、文件处理等都可以定义为一个插件。插件的好处就是无耦合！！！拖入项目可以直接使用，删除后项目也不需要做任何修改，直接build！以后再有新的交互需求你只需要按照上面的步骤创建插件完成功能并把结果返回给JS就可以了！不需要动框架！！

### 5.自定义业务插件（JS侧）

JS侧目前还没有开放插件化功能，但是完成了公共接口封装，提供了成功失败回调函数，便于JS侧处理Native返回的结果：

1. JS调用Native
index.html中引用<script type="text/javascript" src="WKJSBridge.js" ></script>

```js
//功能模块
var service = 'WKFetchPlugin';
//具体功能
var action = 'nativeFentch';
//业务参数
var command = {
    'method':'post',
    'url':'https:www.baidu.com'
}
window.WKJSBridge.callNative(service, action, command, function success(res) {
                                 
                             }, function fail(res) {
                                 
                             });
```

`command`为想要传递的参数。
`service`为Native侧插件类名。
`action`为插件方法名。

2. 详细使用参照Demo。

## 后续功能延伸：

1. JS侧插件化。
2. 基于此引入离线包。
3. 引入flutter。
4. 构建小程序。
5. other  ...

## License

WKJavaScriptBridge is available under the Apache License 2.0. See the [LICENSE](https://github.com/GitWangKai/WKJavaScriptBridge/blob/master/LICENSE) file for more info.

