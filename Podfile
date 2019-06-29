# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'PhotoViewer' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftLint'

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxDataSources', '~> 4.0'
  pod 'RxAlamofire'

  target 'PhotoViewerTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

end
