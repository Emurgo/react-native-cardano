
Pod::Spec.new do |s|
  package = JSON.parse(File.read(File.join(File.dirname(__FILE__), '../package.json')))

  s.name         = "RNCardano"
  s.version      = package['version']
  s.summary      = package['description']

  s.homepage     = "https://github.com/Emurgo/react-native-cardano"
  s.license      = package['license']
  s.author       = { "Crossroad Labs" => "info@crossroad.io" }
  s.source       = { :git => "https://github.com/Emurgo/react-native-cardano.git", :tag => "#{s.version}" }

  s.source_files = 'ios/**/*.{h,m,swift,sh}'
  s.exclude_files = 'android/'
  s.requires_arc = true

  s.ios.deployment_target  = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.script_phase = {
    :name => 'Build Rust Binary',
    :script => 'bash ${PODS_TARGET_SRCROOT}/ios/rust/build.sh',
    :execution_position => :before_compile
  }

  s.pod_target_xcconfig = {
    'USER_HEADER_SEARCH_PATHS' => '$(CONFIGURATION_BUILD_DIR)',
    'OTHER_LIBTOOLFLAGS' => '"-lrust_native_cardano"',
    "ENABLE_BITCODE" => "NO"
  }

  s.libraries = 'resolv'

  s.dependency "React"
end
