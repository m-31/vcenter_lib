# coding: utf-8

require File.expand_path('../lib/vcenter_lib/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'vcenter_lib'
  spec.version       = VcenterLib::VERSION
  spec.authors       = ['Michael Meyling']
  spec.email         = ['search@meyling.com']
  spec.summary       = 'easy access to vcenter informations'
  spec.description   = 'We will see what we can do.'
  spec.homepage      = 'https://github.com/m-31/vcenter_lib'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rbvmomi', '~> 1.11.2'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov', '~> 0.9.0'
end
