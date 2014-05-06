Pod::Spec.new do |s|

  s.name         = "JMUploadProgressNavigationController"
  s.version      = "0.0.2"
  s.summary      = "UINavigationController subclass that provides an interface for displaying an upload progress view"
  s.homepage     = "https://github.com/justinmakaila/JMUploadProgressViewController.git"
  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { 
    :git => "https://github.com/justinmakaila/JMUploadProgressViewController.git",
    :tag => 'v0.0.2' 
  }
  s.source_files = 'JMUploadProgressNavigationController/**/*.{h,m}'
  s.dependency 'LDProgressView', '>= 1.1' 
  s.dependency 'AFNetworking', '~> 2.0.3'
  s.dependency 'HexColors', '~> 2.2.1'
end
