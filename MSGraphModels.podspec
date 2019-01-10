

Pod::Spec.new do |s|



  s.name         = "MSGraphModels"
  s.version      = "0.1.3"
  s.summary      = "Microsoft Graph Models to be used with MSGraphCoreSDK."
  s.description  = <<-DESC
			Use these models to convert raw data from MSGraphCoreSDK to models and back.
                   DESC

  s.homepage     = "http://graph.microsoft.io"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author        = 'Microsoft Graph'

	
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

   s.source       = { :git => "https://github.com/dadheech115/MSGraph-SDK-OBJC-Private.git", :tag=> s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "MSGraphModels/MSGraphModels/**/*.{h,m}"
  s.exclude_files = "MSGraphModels/MSGraphModelsTests/*"
  s.public_header_files = "MSGraphModels/MSGraphModels/**/*.h"


  # ――― Dependencies ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.dependency "MSGraphCoreSDK/Models"


end
