

Pod::Spec.new do |spec|


  spec.name         = "XZWLocationManager"
  spec.version      = "0.0.2"
  spec.summary      = "一个轻松小巧的定位管理类"
  spec.description  = <<-DESC
                  可以随便使用哦，有问题随时联系 751208037@qq.com
                   DESC

  spec.homepage     = "https://github.com/xzw717/XZWLocationManager"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  spec.author             = { "谢增文" => "xiezw94@126.com" }

  # spec.platform     = :ios
  spec.platform     = :ios, "7.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/xzw717/XZWLocationManager.git", :tag => "#{spec.version}" }

  spec.source_files  = "XZWLocationManager", "XZWLocationManager/**/*.{h,m}"

  #spec.exclude_files = "Classes/Exclude"

  spec.framework  = "CoreLocation"


end
