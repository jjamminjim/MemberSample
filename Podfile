project 'MemberSample.xcodeproj'

workspace 'MemberSample'
project 'MemberSample'

platform :ios, '10.0'

target 'MemberSample' do
  use_frameworks!

  # Pods for MemberSample
  pod 'DBC', :git => 'git@github.com:busybusy/DBC-Apple.git'
  pod 'Alamofire'
	pod 'AlamofireImage'

	
	target 'MemberSampleTests' do
		inherit! :search_paths
		
		pod 'MagicalRecord', :inhibit_warnings => true
	end
end
