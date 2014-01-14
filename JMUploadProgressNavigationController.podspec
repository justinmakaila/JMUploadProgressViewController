Pod::Spec.new do |s|

  s.name         = "JMUploadProgressNavigationController"
  s.version      = "0.0.1"
  s.summary      = "UINavigationController subclass that includes methods to show/hide an upload progress bar from the navigation bar"
  s.homepage     = "https://github.com/justinmakaila/JMUploadProgressNavigationController"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "justinmakaila" => "justinmakaila@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://justinmakaila@bitbucket.org/justinmakaila/jmuploadprogressnavigationcontroller.git", :tag => '0.0.2' }
  s.source_files = 'JMUploadProgressNavigationController/**/*.{h,m}'
end
