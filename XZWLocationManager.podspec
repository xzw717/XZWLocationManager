

Pod::Spec.new do |spec|


  spec.name         = "XZWLocationManager"
  spec.version      = "0.0.1"
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
  spec.platform     = :ios, "10.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/xzw717/XZWLocationManager.git", :tag => "#{spec.version}" }

  spec.source_files  = "XZWLocationManager", "XZWLocationManager/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  spec.framework  = "CoreLocation"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
