
Pod::Spec.new do |s|

  s.name         = "MSGraphSDK"
  s.version      = "0.1.2"
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

  s.source_files  = "MSGraphSDK/MSGraphSDK/MSGraphSDK.h"
  s.exclude_files = "MSGraphSDK/MSGraphSDKTests/*"
  s.public_header_files = "MSGraphSDK/MSGraphSDK/MSGraphSDK.h"

  s.subspec "Authentication" do |authentication|
    authentication.source_files = "MSGraphSDK/MSGraphSDK/Authentication/*.{h,m}"
    authentication.public_header_files = "MSGraphSDK/MSGraphSDK/Authentication/*.h"
  end

 s.subspec "Common" do |common|
    common.dependency 'MSGraphSDK/Authentication'
    common.source_files = "MSGraphSDK/MSGraphSDK/{Common,Middleware,GraphContent,HTTPClient}/**/*.{h,m}"
    common.public_header_files = "MSGraphSDK/MSGraphSDK/{Common,Middleware,GraphContent,HTTPClient}/**/*.h"
  end

end
