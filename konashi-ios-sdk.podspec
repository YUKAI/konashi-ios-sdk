Pod::Spec.new do |s|
  s.name         = 'konashi-ios-sdk'
  s.version      = '5.0.1'
  s.summary      = 'iOS SDK for konashi, a wireless physical computing toolkit for iPhone, iPod touch and iPad.'
  s.homepage     = 'http://konashi.ux-xu.com'
  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author       = { 'YUKAI Engineering.Inc' => 'contact@ux-xu.com' }
  s.source       = { :git => 'https://github.com/YUKAI/konashi-ios-sdk.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'Konashi/Konashi/*.{h,m}','Konashi/Konashi/**/*.{h,m}'
  s.requires_arc = true
  s.framework  = 'CoreBluetooth', 'JavaScriptCore'
end
