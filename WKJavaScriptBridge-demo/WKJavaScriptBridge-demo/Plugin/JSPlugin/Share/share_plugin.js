
document.write("<script language=javascript src='wk_bridge_channel.js'></script>");

function Share() {
}

Share.prototype.getService = function(actionArgs, successCallback, failCallback) {
    var service = 'PlusShare';
    var action = 'getServices';
    window.WKJSBridge.callNative(service, action, actionArgs, successCallback, failCallback);
}
Share.prototype.sendWithSystem = function(actionArgs, successCallback, failCallback) {
    var service = 'PlusShare';
    var action = 'sendWithSystem';
    window.WKJSBridge.callNative(service, action, actionArgs, successCallback, failCallback);
}





