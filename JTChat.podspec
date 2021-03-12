#
# Be sure to run `pod lib lint JTChat.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JTChat'
  s.version          = '0.9.4'
  s.summary          = '精特聊天演示'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        精特聊天演示初始化
                       DESC

  s.homepage         = 'https://github.com/OCdes/JTChat'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '76515226@qq.com' => '76515226@qq.com' }
  s.source           = { :git => 'https://github.com/OCdes/JTChat.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.libraries = "c++","c"
  s.xcconfig = { 'VALID_ARCHS' => 'arm64 x86_64 armv7 armv7s', }
  s.ios.deployment_target = '10.0'
  s.source_files = 'JTChat/Classes/**/*'
  s.swift_versions = ['4.0','4.2','5.0']
   s.resource_bundles = {
     'JTChat' => ['JTChat/Assets/*']
   }
   s.static_framework = true
   #s.pod_target_xcconfig = {'DEFINES_MODULE' => 'YES'}
   # , 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/MJRefresh"'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency "KeychainSwift", "~> 18.0.0"
  s.dependency "ESTabBarController-swift"
  s.dependency "Moya", "~> 13.0.0"
  s.dependency "HandyJSON"
  s.dependency "IQKeyboardManagerSwift"
  s.dependency "RxSwift"
  s.dependency "RxCocoa"
  s.dependency "SnapKit", "~>4.0.0"
  s.dependency "Kingfisher"
  s.dependency "YPImagePicker"
  s.dependency "MJRefresh"
  s.dependency "SVProgressHUD"
  s.dependency "DZNEmptyDataSet", "~> 1.8.1"
  s.dependency "ALQRCode"
  s.dependency "CocoaAsyncSocket"
  s.dependency "FMDB"
  s.dependency "JTVoiceConvert"
end
