#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sensors_analytics_flutter_plugin'
  s.version          = '4.0.1'
  s.summary          = 'The official flutter iOS plugin of Sensors Analytics.'
  s.homepage         = 'https://www.sensorsdata.cn/'
  s.license          = { 
    :type => 'Commercial',
    :file => '../LICENSE' }
  s.author           = { "caojiang" => "caojiang@sensorsdata.cn" }
  s.source           = { :git => 'https://github.com/sensorsdata/sensors_analytics_flutter_plugin.git', :tag => "v#{s.version}" }
  s.source_files     = 'ios/Classes/**/*'
  s.public_header_files = 'ios/Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
  s.dependency 'SensorsAnalyticsSDK', ">= 4.9.0"
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.resource_bundle = { 'sensors_analytics_flutter_plugin' => 'ios/Resources/**/*'}
end
