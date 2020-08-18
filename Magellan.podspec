Pod::Spec.new do |s|
  s.name             = 'Magellan'
  s.version          = '0.1.0'

  s.summary          = 'Soramitsu MakKit SDK'

  s.description      = <<-DESC
Library allow fast integration of Soramitsu Places.
                       DESC

  s.homepage         = 'https://github.com/soramitsu'
  s.license          = { :type => 'GPL 3.0', :file => 'LICENSE' }
  s.author           = { 'Andrei Marin' => 'marin@soramitsu.co.jp', 'Ruslan Rezin' => 'rezin@soramitsu.co.jp', 'Iskander Foatov' => 'foatov@soramitsu.co.jp' }
  s.source           = { :git => 'https://github.com/soramitsu/Magellan-iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.static_framework = true
  s.source_files = 'Magellan/Classes/**/*.swift'
  s.ios.resource_bundle = { 'Magellan' => ['Magellan/Assets/*.xcassets' , 'Magellan/Assets/Lang/**/*'] }


  s.frameworks = 'UIKit', 'CoreImage'
  s.dependency 'RobinHood', '~> 2.3.0'
  s.dependency 'SoraUI', '~> 1.8.7'
  s.dependency 'SoraFoundation/DateProcessing', '~> 0.7.0'
  s.dependency 'SoraFoundation/NotificationHandlers', '~> 0.7.0'
  s.dependency 'SoraFoundation/Localization', '~> 0.7.0'
  s.dependency 'GoogleMaps', '= 3.9.0'
  s.dependency 'Google-Maps-iOS-Utils'
  s.dependency 'SVProgressHUD'

end
