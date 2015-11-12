Pod::Spec.new do |s|
  s.name = 'YSReleaseNotesView'
  s.version = '0.0.4'
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
    
 s.dependency 'TWSReleaseNotesView', '1.2.1-yusuga.1'
 s.dependency 'KLCPopup'
 s.dependency 'LumberjackLauncher'
end