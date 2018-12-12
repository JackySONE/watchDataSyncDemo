# Uncomment the next line to define a global platform for your project

use_frameworks!

def shared_pods
  pod 'RealmSwift'
end

target 'WatchDataSyncDemo' do
   platform :ios, '8.0'

  shared_pods

  target 'WatchDataSyncDemoTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'Watch Extension' do
     platform :watchos, '2.0'

    shared_pods
end

