
Pod::Spec.new do |s|
  package = JSON.parse(File.read(File.join(File.dirname(__FILE__), '../package.json')))

  s.name         = "RNCardano"
  s.version      = package['version']
  s.summary      = package['description']

  s.homepage     = "https://github.com/Emurgo/react-native-cardano"
  s.license      = package['license']
  s.author       = { "Crossroad Labs" => "info@crossroad.io" }
  s.source       = { :git => "https://github.com/Emurgo/react-native-cardano.git", :tag => "#{s.version}" }

  s.source_files  = "./**/*"
  s.exclude_files = './../android/', '../node_modules/'
  s.requires_arc = true

  s.ios.deployment_target  = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.script_phase = {
    :name => 'Build Rust Binary',
    :script => 'bash ${PODS_TARGET_SRCROOT}/rust/build.sh',
    :execution_position => :before_compile
  }

  s.pod_target_xcconfig = {
    'USER_HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/rust" "$(CONFIGURATION_BUILD_DIR)"',
    'LIBRARY_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/rust"',
    'OTHER_LIBTOOLFLAGS' => '"-lrust_native_cardano"'
  }

  s.libraries = 'resolv'

  s.dependency "React"
end
