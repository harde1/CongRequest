
Pod::Spec.new do |s|
  s.name         = "CongRequest"
  s.version      = "0.0.1"
  s.summary      = "一个建立afn封装包YTKNetwork下的再次扩展包,可以称之为YTKNetwork二次扩展包"
  
  s.description  = "一个建立afn封装包YTKNetwork下的再次扩展包,可以称之为YTKNetwork二次扩展包,把json检查给简化了,json空值null检测加了进去,并且做了排出空值处理,还增加了自动产生合格接口文件的类,接口文件代码生代码"
  s.homepage     = "http://blog.csdn.net/jianrenbubai/article/details/48847969"
  s.license      = "MIT"
  s.author             = { "剑仁不败" => "harde1@163.com","敏钦" => "799621181@qq.com" }
  s.source       = { :git => "https://github.com/harde1/CongRequest.git", :commit => '5fd642e98e028c6ab0e78ac20bcb361833f55a55' }
  s.source_files  = "CongRequest/*.{h,m}"
  s.dependency 'YTKNetwork', '~> 0.5.0'
end
