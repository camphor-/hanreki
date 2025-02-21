# frozen_string_literal: true

require_relative "lib/hanreki/version"

Gem::Specification.new do |spec|
  spec.name = "hanreki"
  spec.version = Hanreki::VERSION
  spec.authors = ["CAMPHOR-"]
  spec.email = ["support@camph.net"]

  spec.summary = "Simple schedule manager for CAMPHOR-"
  spec.description = "Simple schedule manager for CAMPHOR-"
  spec.homepage = "https://github.com/camphor-/hanreki"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/camphor-/hanreki"
  spec.metadata["changelog_uri"] = "https://github.com/camphor-/hanreki/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.3", ">= 1.3.2"
  spec.add_dependency "json-schema", "~> 5.1", ">= 5.1.1"
  spec.add_dependency "icalendar", "~> 2.10", ">= 2.10.3"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
