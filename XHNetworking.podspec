Pod::Spec.new do |s|
  s.name         = "XHNetworking"
  s.version      = "1.0"
  s.summary      = "基于AFNNetworking 3.x的轻量级数据请求库,支持数据自动/手动缓存"
  s.homepage     = "https://github.com/CoderZhuXH/XHNetworking"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'Zhu Xiaohui' => '977950862@qq.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/CoderZhuXH/XHNetworking.git", :tag => s.version }
  s.source_files = "XHNetworking/**/*.{h,m}"
  s.requires_arc = true
  s.dependency "AFNetworking", "~> 3.0.4"
  
end
