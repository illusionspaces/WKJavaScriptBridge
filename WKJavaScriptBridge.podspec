

Pod::Spec.new do |spec|


  spec.name         = "WKJavaScriptBridge"
  spec.version      = "0.1.2"
  spec.summary      = "基于WKWebView构建的Hybrid框架，支持iOS8+。"
  spec.homepage     = "https://github.com/GitWangKai/WKJavaScriptBridge"
  spec.license      = { :type => "Apache License 2.0", :file => "LICENSE" }
  spec.author             = { "王凯" => "18500052382@163.com" }
  spec.source       = { :git => "https://github.com/GitWangKai/WKJavaScriptBridge.git", :tag => "#{spec.version}" }
  spec.source_files  = "WKJavaScriptBridge-demo/WKJavaScriptBridge-demo/WKJavaScriptBridge/*.{h,m}"
  spec.platform = :ios, '8.0'
end
