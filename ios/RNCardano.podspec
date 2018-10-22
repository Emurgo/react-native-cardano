
Pod::Spec.new do |s|
  package = JSON.parse(File.read(File.join(File.dirname(__FILE__), '../package.json')))

  s.name         = "RNCardano"
  s.version      = package['version']
  s.summary      = package['description']

  s.homepage     = "https://github.com/crossroadlabs/react-native-cardano"
  s.license      = package['license']
  s.author       = { "Crossroad Labs" => "info@crossroad.io" }
  s.source       = { :git => "https://github.com/crossroadlabs/react-native-cardano.git", :tag => "master" }

  s.source_files  = "./*.{h,m}"
  s.requires_arc = true

  s.ios.deployment_target  = '10.0'
  s.tvos.deployment_target  = '10.0'

  s.script_phase = {
    :name => 'Build Rust Binary',
    :script => 'bash ${PODS_TARGET_SRCROOT}/rust/build.sh',
    :execution_position => :before_compile
  }

  s.xcconfig = {
    'USER_HEADER_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/rust"',
    'LIBRARY_SEARCH_PATHS' => '"${PODS_TARGET_SRCROOT}/rust"',
    'OTHER_LIBTOOLFLAGS' => '"-lrust_native_cardano"'
  }

  s.dependency "React"
end

  