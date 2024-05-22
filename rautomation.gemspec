# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rautomation/adapter/helper', __FILE__)
require File.expand_path('../lib/rautomation/version', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{rautomation}
  s.version = RAutomation::VERSION
  s.authors = [%q{Jarmo Pertman}]
  s.email = %q{jarmo.p@gmail.com}
  s.description = %q{RAutomation is a small and easy to use library for helping out to automate windows and their controls
for automated testing.

RAutomation provides:
* Easy to use and user-friendly API (inspired by Watir http://www.watir.com)
* Cross-platform compatibility
* Easy extensibility - with small scripting effort it's possible to add support for not yet
  supported platforms or technologies}
  s.homepage = %q{http://github.com/jarmo/RAutomation}
  s.summary = %q{Automate windows and their controls through user-friendly API with Ruby}
  s.license = "MIT"
  s.platform = Gem::Platform.local if s.platform == 'ruby'

  missing_externals = RAutomation::Adapter::Helper.find_missing_externals
  if missing_externals.any?
    missing_externals.each { |ext_location | puts "Missing external: #{ext_location}" }
    raise Gem::InstallError,
          "One or more required DLL files are missing. See Rake task 'compile' in order to build."
  end

  ext_locations = RAutomation::Adapter::Helper::ADAPTER_DIRS
  winforms_files = Dir[
    "ext/WindowsForms/Release/*.dll",
    "ext/WindowsForms/Release/*.exe"
  ]

  s.files         = `git ls-files`.split("\n") + ext_locations + winforms_files
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("ffi", "~> 1.15.0")
  s.add_development_dependency("rspec", "~> 3.9")
  s.add_development_dependency("rake", "~> 10.5")
  s.add_development_dependency("yard", "~> 0.9")
  s.add_development_dependency("redcarpet", "~> 3.5")
  s.add_development_dependency("github-markup", "~> 3.0")
end
