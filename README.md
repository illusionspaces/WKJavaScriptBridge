# WKJavaScriptBridge


[![Version](https://img.shields.io/cocoapods/v/WKJavaScriptBridge.svg?style=flat)](http://cocoapods.org/pods/WKJavaScriptBridge)
[![Pod License](http://img.shields.io/cocoapods/l/WKJavaScriptBridge.svg?style=flat)](https://opensource.org/licenses/Apache-2.0)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)
![](https://img.shields.io/badge/language-objc-orange.svg)
![ARC](https://img.shields.io/badge/ARC-orange.svg)


## Link
* Blog : 

[《写一个易于维护使用方便性能可靠的Hybrid框架（四）—— 框架构建》](https://juejin.im/post/5cd2c6a2f265da037516ba1c)

[《写一个易于维护使用方便性能可靠的Hybrid框架（三）—— 配置插件》](https://juejin.im/post/5c0ca4bde51d4541284cab56)

[《写一个易于维护使用方便性能可靠的Hybrid框架（二）—— 插件化》](https://juejin.im/post/5c0a41e5f265da61335664ba)

[《写一个易于维护使用方便性能可靠的Hybrid框架（一）—— 思路构建》](https://juejin.im/post/5c07d95ee51d451d930b04c7)


## 特性

- 一行代码集成。
- 异步调用。
- 支持业务模块化分离。
- 支持业务模块白名单机制，提升安全性。


## 安装

### 方法一:Cocoapods
- 1、:

```objc
在Podfile文件里面添加:pod 'WKJavaScriptBridge'
```
- 2、:对应文件添加头文件

```objc
#import "WKJavaScriptBridge.h"
```

### 方法二:手动添加
- 1、下载WKJavaScriptBridge，将WKJavaScriptBridge文件夹拖入到你的工程中

- 2、引入头文件:

```objc
#import "WKJavaScriptBridge.h"
```


## 用法
- 1、:

```objc
//在创建WKWebView的类扩展中加入
@property (nonatomic, strong) WKJavaScriptBridge *bridge;
```
- 2、:

```objc
//在创建WKWebView的地方调用此方法
self.bridge = [WKJavaScriptBridge bindBridgeWithWebView:yourwebView];
```
- 3、:

```objc
//开启白名单，默认关闭。若开启，插件需要进行注册`@WKRegisterWhiteList(你的模块类名)`，参照Demo。
[self.bridge openWhiteList:YES];
```

## License

WKJavaScriptBridge is available under the Apache License 2.0. See the [LICENSE](https://github.com/GitWangKai/WKJavaScriptBridge/blob/master/LICENSE) file for more info.

