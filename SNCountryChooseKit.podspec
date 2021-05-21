#
# Be sure to run `pod lib lint SNCountryChooseKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SNCountryChooseKit'
  s.version          = '0.1.3'
  s.summary          = 'SNCountryChooseKit 是一个国家、省、市选择模块，包含自定定位获取'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SNCountryChooseKit 是一个国家、省、市选择模块，包含自定定位获取
                       DESC

  s.homepage         = 'https://github.com/keroushe/SNCountryChooseKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'keroushe' => '935823671@qq.com' }
  s.source           = { :git => 'https://github.com/keroushe/SNCountryChooseKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SNCountryChooseKit/Classes/**/*.{h,m}'
  s.resource     = 'SNCountryChooseKit/Assets/SNCountryChooseKit.bundle'
  
  # s.resource_bundles = {
  #   'SNCountryChooseKit' => ['SNCountryChooseKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'SDWebImage', '~> 5.2.3'
  s.dependency 'YYKit', '~> 1.0.9'
  s.dependency 'SNCountryCodeFlagManage', '~> 0.1.1'
  s.dependency 'KHLocationManage', '~> 0.1.1'
end
