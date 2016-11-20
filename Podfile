# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def domain_pods
    pod 'RxSwift'
end

target 'PokerPalm' do
  domain_pods
  pod 'RxCocoa'

end

target 'Platform' do
  pod 'RealmSwift'
  pod 'RxRealm'
  domain_pods
  target 'PlatformTests' do
    inherit! :search_paths
    pod 'RxTest'
    pod 'Nimble'
  end
end

target 'Domain' do
  domain_pods
  target 'DomainTests' do
      inherit! :search_paths
      pod 'RxTest'
  end
end
