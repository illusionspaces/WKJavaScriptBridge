document.write("<script language=javascript src='WKJSBridge.js'></script>");
;
(function (window) {
    var bridgeConfig = {};
    var wk_bridge = /** @class */ (function () {
       function wk_bridge() {
       }
        /**
         * 调用 Natvie Post 网络请求 方法
         * @param actionArgs 数据
         * @param callback 调用回调
         */
        wk_bridge.prototype.nativePost = function (actionArgs, successCallback, failCallback) {
            var fetchConfig = bridgeConfig.fetch_id;
            var service = fetchConfig.service;
            var action = fetchConfig.action.action_post;
            window.WKJSBridge.callNative(service, action, actionArgs, successCallback, failCallback);
        };
                                    
        /**
         * 调用 Natvie Get 网络请求 方法
         * @param actionArgs 数据
         * @param callback 调用回调
         */
        wk_bridge.prototype.nativeGet = function (actionArgs, successCallback, failCallback) {
            var fetchConfig = bridgeConfig.fetch_id;
            var service = fetchConfig.service;
            var action = fetchConfig.action.action_get;
            window.WKJSBridge.callNative(service, action, actionArgs, successCallback, failCallback);
        };
        return wk_bridge;
    }());
    // 初始化 wk_bridge
    var wk_bridgeInstance = new wk_bridge();
 
  /**
   * wk_bridge 配置 加载native插件配置
   */
    var WKJSBridgeConfig = /** @class */ (function () {
        function WKJSBridgeConfig() {
        }
       // 静态属性和方法
       WKJSBridgeConfig.moduleName = 'WKJSBridgeConfig';
       WKJSBridgeConfig.init = function () {
           window.wk_bridge = wk_bridgeInstance; // 设置新的 wk_bridge 作为全局对象
       };
                                          
       WKJSBridgeConfig.loadConfigFromNative = function () {
           window.WKJSBridge.callNative(WKJSBridgeConfig.moduleName, 'fetchConfig', {}, function success(res) {
                                           bridgeConfig = res; //native侧插件配置（iOS & android）两端需要相同的serviceId和actionId
                                        });
       };
       
       return WKJSBridgeConfig;
    }());
    // 初始化 wk_bridge
 
    window.WKJSBridgeConfig = WKJSBridgeConfig;
    window.WKJSBridgeConfig.init(); // wk_bridge 配置初始化
    window.WKJSBridgeConfig.loadConfigFromNative(); // 加载 native 上的配置
})(window);
