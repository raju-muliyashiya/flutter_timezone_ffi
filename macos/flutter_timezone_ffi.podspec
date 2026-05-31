Pod::Spec.new do |s|
  s.name             = 'flutter_timezone_ffi'
  s.version          = '0.0.1'
  s.summary          = 'FFI-based timezone detection for Flutter'
  s.homepage         = 'https://github.com/raju-muliyashiya/flutter_timezone_ffi'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Raju Muliyashiya' => '24muliyashiya@gmail.com' }
  s.source           = { :path => '.' }
  # The Classes/ wrappers #include the shared sources under ../src.
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
