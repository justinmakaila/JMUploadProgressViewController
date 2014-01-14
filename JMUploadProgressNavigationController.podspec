Pod::Spec.new do |s|

  s.name         = "JMUploadProgressNavigationController"
  s.version      = "0.0.2"
  s.summary      = "UINavigationController subclass that provides an interface for displaying an upload progress view"
  s.homepage     = "https://bitbucket.org/justinmakaila/jmuploadprogressnavigationcontroller"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { 
    :git => "https://justinmakaila@bitbucket.org/justinmakaila/jmuploadprogressnavigationcontroller.git",
    :tag => 'v0.0.2' 
  }
  s.source_files = 'JMUploadProgressNavigationController/**/*.{h,m}'
  s.dependency 'LDProgressView' 
  s.dependency 'AFNetworking'
end
