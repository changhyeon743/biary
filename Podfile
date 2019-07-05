# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'biary' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for biary
    pod 'SwiftyJSON', '~> 4.0'
    pod 'Alamofire'
pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
pod 'PeekPop', '~> 1.0'
pod 'UITextView+Placeholder'

pod 'SDWebImage', '~> 4.0'
pod 'FacebookCore'
    pod 'FBSDKLoginKit'
    pod 'Disk', '~> 0.4.0'
pod 'ActionSheetPicker-3.0', '~> 2.3.0'
pod 'AMPopTip'
pod 'Carte'
pod "SwiftRater"
pod 'CropViewController'
pod 'Bolts'

end

post_install do |installer|
  pods_dir = File.dirname(installer.pods_project.path)
  at_exit { `ruby #{pods_dir}/Carte/Sources/Carte/carte.rb configure` }
end
