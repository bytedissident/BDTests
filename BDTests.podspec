#
# Be sure to run `pod lib lint BDTests.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BDTests'
  s.version          = '0.0.1'
  s.summary          = 'A Swift UITesting framework. Intended to simplify stubbing UITests'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bytedissident/BDTests'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bytedissident' => 'dbronston@me.com' }
  s.source           = { :git => 'https://github.com/bytedissident/BDTests.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BDTests/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BDTests' => ['BDTests/Assets/*.png']
  # }

   #s.public_header_files = 'Pod/Classes/**/*'
   #s.frameworks = 'XCTest'
   s.dependency 'OHHTTPStubs'
   s.dependency 'OHHTTPStubs/Swift'
end
