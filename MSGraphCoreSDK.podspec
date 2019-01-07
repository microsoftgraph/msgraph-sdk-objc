
Pod::Spec.new do |s|


  s.name         = "MSGraphCoreSDK"
  s.version      = "0.1.1"
  s.summary      = "Microsoft Graph ObjC SDK."

  s.description  = <<-DESC
		   Integrate the Microsoft Graph API into your iOS App!
                   DESC

  s.homepage     = "http://graph.microsoft.io"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author        = 'Microsoft Graph'


  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"

  s.source       = { :git => "https://github.com/microsoftgraph/msgraph-sdk-objc.git", :branch => "vidadhee/MacSupport" }



  s.source_files  = "MSGraphCoreSDK/MSGraphCoreSDK/MSGraphCoreSDK.h"
  s.exclude_files = "MSGraphCoreSDK/MSGraphCoreSDKTests/*"
  s.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/MSGraphCoreSDK.h"

#s.subspec "Core" do |core|
 #   core.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/**/*.{h,m}"
 #   core.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/*/*.h"
  #  core.exclude_files = "MSGraphCoreSDK/MSGraphCoreSDKTests/*"
 # end

#s.default_subspec = "Core"

  s.subspec "Models" do |models|
    models.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/Models/*.{h,m}"
    models.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/Models/*.h"
  end



  s.subspec "Authentication" do |authentication|
    authentication.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/Authentication/*.{h,m}"
    authentication.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/Authentication/*.h"
  end

 

 s.subspec "Common" do |common|
    common.dependency 'MSGraphCoreSDK/Authentication'
    common.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/{Common,Middleware,GraphContent,HTTPClient}/**/*.{h,m}"
    common.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/{Common,Middleware,GraphContent,HTTPClient}/**/*.h"
  end

 #s.subspec "Middleware" do |middleware|
  #  middleware.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/Middleware/**/*.{h,m}"
   # middleware.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/Middleware/**/*.h"
  #end

#s.subspec "GraphContent" do |graphContent|
  #  graphContent.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/GraphContent/**/*.{h,m}"
   # graphContent.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/GraphContent/**/*.h"
  #end

#s.subspec "HTTPClient" do |httpClient|
  #  httpClient.source_files = "MSGraphCoreSDK/MSGraphCoreSDK/HTTPClient/**/*.{h,m}"
  #  httpClient.public_header_files = "MSGraphCoreSDK/MSGraphCoreSDK/HTTPClient/**/*.h"
 # end



  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
