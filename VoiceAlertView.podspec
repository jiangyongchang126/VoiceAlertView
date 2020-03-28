

Pod::Spec.new do |s|

  s.name         = "VoiceAlertView"
  s.version      = "0.0.1"
  s.summary      = "A short description of VoiceAlertView."
  s.description  = "a VoiceAlertView demo" 
  s.homepage     = "https://github.com/jiangyongchang126/VoiceAlertView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "jianggongzi" => "jiang_yongchang@126.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/jiangyongchang126/VoiceAlertView.git", :tag => "0.0.1" }
  s.requires_arc = true #是否支持ARC

  s.source_files  =  "VoiceAlertView/VoiceAlertView/Voice/**/*.{h,m}"

  s.frameworks = "Foundation","UIKit"


end
