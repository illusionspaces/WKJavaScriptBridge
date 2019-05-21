

Pod::Spec.new do |spec|


  spec.name         = "SHRMJavaScriptBridge"
  spec.version      = "0.0.2"
  spec.summary      = "一个同时支持WKWebView和UIWebView的Hybrid框架，支持iOS8+。"
  spec.homepage     = "https://github.com/GitWangKai/SHRMJavaScriptBridge"
  spec.license      = { :type => "Apache License 2.0", :file => "LICENSE" }
  spec.author             = { "王凯" => "18500052382@163.com" }
  spec.source       = { :git => "https://github.com/GitWangKai/SHRMJavaScriptBridge.git", :tag => "#{spec.version}" }
  spec.source_files  = "SHRMJavaScriptBridge/*.{h,m}"
  spec.platform = :ios, '8.0'
end
