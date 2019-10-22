;
(function (window) {
    ;
    var WKJSBridge = /** @class */ (function () {
        function WKJSBridge() {
            this.uniqueId = 1;
            this.callbackCache = {};
            this.eventCallbackCache = {};
        }
        /**
         * 调用 Natvie 方法
         * @param service 模块
         * @param action 方法
         * @param actionArgs 数据
         * @param callback 调用回调
         */
        WKJSBridge.prototype.callNative = function (service, action, actionArgs, successCallback, failCallback) {
            var message = {
                service: service || 'default',
                action: action,
                actionArgs: actionArgs,
                callbackId: null
            };
            if (successCallback || failCallback) {
                // 拼装 callbackId
                var callbackId = 'cb_' + message.service + '_' + action + '_' + (this.uniqueId++) + '_' + new Date().getTime();                // 缓存 callback，用于在 Native 处理完消息后，通知 H5
                this.callbackCache[callbackId] = {success:successCallback, fail:failCallback};;
                // 追加 callbackId 属性
                message.callbackId = callbackId;
            }
            // 发送消息给 Native
            window.webkit.messageHandlers.WKJSBridgeMessageName.postMessage(JSON.stringify(message));
        };
        /**
         * 用于处理来自 Native 的消息
         * @param callbackMessage 回调消息
         */
        WKJSBridge.prototype._handleMessageFromNative = function (messageString) {
            var callbackMessage = JSON.parse(messageString);
            var status = messageString.status;
            var callback = this.callbackCache[callbackMessage.callbackId];
            if (callback) { // 执行 callback 回调，并删除缓存的 callback
                if (status = '0') {//失败回调
                   callback.fail(callbackMessage.data);
                }else {//成功回调
                   callback.success(callbackMessage.data);
                }
                this.callbackCache[callbackMessage.callbackId] = null;
                delete this.callbackCache[callbackMessage.callbackId];
            }
            
        };
        return WKJSBridge;
    }());
    // 初始化 KKJSBridge
    window.WKJSBridge = new WKJSBridge(); // 设置新的 JSBridge 作为全局对象
})(window);
