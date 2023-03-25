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

  ext_locations = [
          "ext/IAccessibleDLL/Release/IAccessibleDLL.dll",
          "ext/UiaDll/Release/UiaDll.dll",
          "ext/UiaDll/Release/RAutomation.UIA.dll"
  ]

  winforms_files = Dir[
          "ext/WindowsForms/Release/*.dll",
          "ext/WindowsForms/Release/*.exe"
  ]

  RAutomation::Adapter::Helper.find_missing_externals(ext_locations).each do |ext|
    RAutomation::Adapter::Helper.build_solution(ext)
  end

  # move .dll files and get array containing paths
  # send first three externals and first three characters from platform eg 'x86' from 'x86-mingw32'
  externals = RAutomation::Adapter::Helper.move_adapter_dlls(ext_locations[0, 3], s.platform.to_s[0, 3])

  s.files         = `git ls-files`.split("\n") + externals + winforms_files
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("ffi", "~> 1.15.0")
  s.add_development_dependency("rspec", "~> 3.9")
  s.add_development_dependency("rake", "~> 10.5")
  s.add_development_dependency("yard", "~> 0.9")
  s.add_development_dependency("redcarpet", "~> 3.5")
  s.add_development_dependency("github-markup", "~> 3.0")
end
