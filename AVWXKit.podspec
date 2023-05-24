Pod::Spec.new do |s|
  s.name             = 'AVWXKit'
  s.version          = '1.0.0'
  s.summary          = 'A short description of AVWXKit.'

  s.description      = "Swift client for https://avwx.rest/"

  s.homepage         = 'https://github.com/JanC/AVWXKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NA' => 'jan.chaloupecky@gmail.com' }
  s.source           = { :git => 'git@github.com:JanC/AVWXKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = "10.0"
  s.swift_version = "5.0"

  s.source_files = 'Sources/**/*.swift'
  s.test_spec 'Tests' do |test_spec|
    test_spec.requires_app_host = false
    test_spec.source_files = ['Tests/**/*.{swift}']
    test_spec.dependency 'Nimble', "~> 8.0.2"
    test_spec.dependency 'Quick', "~> 2.1.0"
    test_spec.dependency  'OHHTTPStubs', "~> 8.0.0"
  end

end
