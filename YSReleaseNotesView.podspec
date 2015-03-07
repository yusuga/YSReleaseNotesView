Pod::Spec.new do |s|
  s.name = 'YSReleaseNotesView'
  s.version = '0.0.2'
  s.summary = 'YSReleaseNotesView'
  s.homepage = 'https://github.com/yusuga/YSReleaseNotesView'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSReleaseNotesView.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/YSReleaseNotesView/*.{h,m}'
  s.resources    = 'Classes/YSReleaseNotesView/**/*.{xib,lproj}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
  
  s.prefix_header_contents = "#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
    static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif"
  
 s.dependency 'TWSReleaseNotesView'
 s.dependency 'KLCPopup'
 s.dependency 'YSCocoaLumberjackHelper'
end