#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint farly_flutter_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'farly_flutter_sdk'
  s.version          = '1.0.3'
  s.summary          = 'Farly Flutter SDK'
  s.description      = <<-DESC
The Farly Flutter SDK is a plugin for Flutter that allows you to integrate the Farly SDK into your Flutter app.
                       DESC
  s.homepage         = 'https://farly.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Farly' => 'hello@farly.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Farly', '~> 1.0.3'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
