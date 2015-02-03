source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'
inhibit_all_warnings!
pod 'LRResty', '~> 0.11.0'
pod 'SVProgressHUD', '1.1.2'
pod 'FontAwesome-iOS'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'GHStreaks/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
