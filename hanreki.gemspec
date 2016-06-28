# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanreki/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanreki'
  spec.version       = Hanreki::VERSION
  spec.authors       = ['CAMPHOR-']
  spec.email         = ['support@camph.net']

  spec.summary       = 'Simple schedule manager for CAMPHOR-'
  spec.description   = 'Simple schedule manager for CAMPHOR-'
  spec.homepage      = 'https://github.com/camphor-/hanreki'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'icalendar', '~> 2.3'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
