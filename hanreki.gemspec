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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
                         f.match(%r{^(
                           (bin|test|spec|features)/|
                           \.gitignore|\.rspec|\.travis\.yml|Rakefile
                         )}x)
                       }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'icalendar', '~> 2.3'
  spec.add_dependency 'json-schema', '~> 2.7'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
