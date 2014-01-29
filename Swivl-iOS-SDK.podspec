Pod::Spec.new do |s|
  s.name     = 'Swivl-iOS-SDK'
  s.version  = '0.0.7'
  s.license  = 'NO-LICENSE'
  s.summary  = 'Swivl Hardware 2 SDK.'
  s.homepage = 'https://github.com/swivl/Swivl-iOS-SDK'
  s.authors  = { 'Mikhail Levitskiy' => 'mikhail@satarii.com', 'Sergei Me' => 'mer.sergei@gmail.com'}
  s.source   = { :git => 'https://github.com/Swivl/Swivl-iOS-SDK.git', :tag => s.version.to_s  }
  s.source_files = 'SwivlCommonLib/**/*.{h,m}'
  s.public_header_files = 'SwivlCommonLib/**/*.h'
  s.xcconfig = {'OTHER_LDFLAGS' => "${PODS_ROOT}/#{s.name}/Universal/libSwivlCommonLib.a"}
  s.resources = 'Universal/**/*.a'
  s.requires_arc = false
  s.ios.deployment_target = '5.0'
end
