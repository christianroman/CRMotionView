Pod::Spec.new do |s|

  s.name         = "CRMotionView"
  s.version      = "0.1"
  s.summary      = "Custom motion photo viewer inspired by Facebook Paper."
  s.homepage     = "https://github.com/chroman/CRGradientNavigationBar"
  s.screenshots  = "http://chroman.me/wp-content/uploads/2013/10/main.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Christian Roman" => "chroman16@gmail.com" }
  s.source       = {
    :git => "https://github.com/chroman/CRMotionView.git",
    :tag => "#{s.version}"
  }

  s.platform     = :ios, '6.0'
  s.source_files  = 'CRMotionView/*.{h,m}'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'CoreMotion'

end
