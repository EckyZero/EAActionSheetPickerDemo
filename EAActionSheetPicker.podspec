Pod::Spec.new do |s|
  s.name             = "EAActionSheetPicker"
  s.version          = "1.1.0"
  s.summary          = "A simple UIPickerView/UIDatePicker embedded inside a UIActionSheet"
  s.homepage         = "https://github.com/EckyZero/EAActionSheetPickerDemo"
  s.screenshots      = "https://raw.github.com/EckyZero/EAActionSheetPickerDemo/master/EAActionSheetPickerDemo/Screenshot(2).PNG"
  s.license          = 'MIT'
  s.author           = { "Erik Andersen" => "erik.andersen@mcubedlabs.com" }
  s.source           = { :git => "https://github.com/EckyZero/EAActionSheetPickerDemo/EAActionSheetPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXAMPLE'

  s.platform     = :ios, '6.0'
  # s.ios.deployment_target = '5.0'
  # s.osx.deployment_target = '10.7'
  s.requires_arc = true

  s.source_files = 'Classes'

  # s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'JSONKit', '~> 1.4'
end
