# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def domain_pods
    pod 'RxSwift', '3.0.0-rc.1'
end

target 'PokerPalm' do
  domain_pods
  pod 'RxCocoa', '3.0.0-rc.1'

end

target 'Platform' do
  pod 'RealmSwift'
  pod 'RxRealm', '~> 0.2.6'
  domain_pods
end

target 'Domain' do
  domain_pods
  target 'DomainTests' do
      inherit! :search_paths
      pod 'RxTest', '3.0.0-rc.1'
  end
end
