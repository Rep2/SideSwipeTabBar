Pod::Spec.new do |s|
  s.name             = 'SideSwipeTabBar'
  s.version          = '0.1.0'
  s.summary          = 'UITabBarController with side swipe.'
  s.homepage         = 'https://github.com/Ivan Rep/SideSwipeTabBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ivan Rep' => 'ivan.rep2@gmail.com' }
  s.source           = { :git => 'https://github.com/Ivan Rep/SideSwipeTabBar.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.source_files = 'SideSwipeTabBar/Classes/**/*'
  s.frameworks = 'UIKit'
end
