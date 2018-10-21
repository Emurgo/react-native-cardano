
Pod::Spec.new do |s|
  package = JSON.parse(File.read(File.join(File.dirname(__FILE__), '../package.json')))

  s.name         = "RNCardano"
  s.version      = package['version']
  s.summary      = package['description']

  s.homepage     = "https://github.com/crossroadlabs/react-native-cardano"
  s.license      = package['license']
  s.author       = { "Crossroad Labs" => "info@crossroad.io" }
  s.source       = { :git => "https://github.com/crossroadlabs/react-native-cardano.git", :tag => "master" }
  s.source_files  = "./*.{h,m,swift}"

  s.ios.deployment_target  = '10.0'

  s.swift_version = '4.2'
  s.requires_arc = true

  s.dependency "React"
end

  