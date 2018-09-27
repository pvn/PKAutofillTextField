#
# Be sure to run `pod lib lint PKAutofillTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PKAutofillTextField'
  s.version          = '1.0.1'
  s.summary          = 'Smart textfield holds existing inputs'
  s.description      = 'Smart textfield holds existing inputs. E.g You do not want to enter server address again by typing than selecting from existing inputs'
  #TODO: 'need to hande CATransition issue while deleting all the items'
  s.homepage         = 'https://github.com/pvn/PKAutofillTextField'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Praveen Kumar Shrivastav' => 'composetopraveen@gmail.com' }
  s.source           = { :git => 'https://github.com/pvn/PKAutofillTextField.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/praveen_tech'
  s.ios.deployment_target = '10.0'
  s.source_files = 'PKAutofillTextField/Classes/**/*'
  s.swift_version = '4.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
