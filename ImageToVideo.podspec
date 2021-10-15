Pod::Spec.new do |s|
  s.name         = "ImageToVideo"
  s.version      = "0.1.7"
  s.summary      = "Simple export video from image array"
  s.homepage     = "https://github.com/thanhminhkma/ImagetoVideo"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = "Tuyen LX"
  s.source       = { :git => "https://github.com/thanhminhkma/ImagetoVideo.git", :tag => s.version.to_s }
  s.frameworks   = 'UIKit', 'Foundation', 'AVFoundation', 'Photos'
  s.requires_arc = true
  s.source_files = 'ImageToVideo/*.swift'
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.0'
end