
Pod::Spec.new do |s|

  s.name         = "MSGraphClientSDK"
  s.version      = "1.0.0"
  s.summary      = "Microsoft Graph ObjC SDK."

  s.description  = <<-DESC
		   Integrate the Microsoft Graph API into your iOS App!
                   DESC

  s.homepage     = "http://graph.microsoft.io"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author        = 'Microsoft Graph'


  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/microsoftgraph/msgraph-sdk-objc.git", :tag=> s.version }

  s.source_files  = "MSGraphClientSDK/MSGraphClientSDK/MSGraphClientSDK.h"
  s.exclude_files = "MSGraphClientSDK/MSGraphClientSDKTests/*"
  s.public_header_files = "MSGraphClientSDK/MSGraphClientSDK/MSGraphClientSDK.h"

  s.subspec "Authentication" do |authentication|
    authentication.source_files = "MSGraphClientSDK/MSGraphClientSDK/Authentication/*.{h,m}"
    authentication.public_header_files = "MSGraphClientSDK/MSGraphClientSDK/Authentication/*.h"
  end

 s.subspec "Common" do |common|
    common.dependency 'MSGraphClientSDK/Authentication'
    common.source_files = "MSGraphClientSDK/MSGraphClientSDK/{Common,Middleware,GraphContent,HTTPClient,GraphTasks}/**/*.{h,m}"
    common.public_header_files = "MSGraphClientSDK/MSGraphClientSDK/{Common,Middleware,GraphContent,HTTPClient,GraphTasks}/**/*.h"
  end

end
