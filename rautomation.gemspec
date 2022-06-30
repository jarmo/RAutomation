# -*- encoding: utf-8 -*-
require File.expand_path('../ext/ext_helper', __FILE__)

Gem::Specification.new do |s|
  s.name = %q{rautomation}
  s.version = File.read("VERSION").strip
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

  dll_locations = [
          "ext/IAccessibleDLL/Release/IAccessibleDLL.dll",
          "ext/UiaDll/Release/UiaDll.dll",
          "ext/UiaDll/Release/RAutomation.UIA.dll"
  ]

  # move .dll files and get array containing paths, append WindowsForms.exe
  externals = ExternalBinaries::move_files(dll_locations) << "ext/WindowsForms/Release/WindowsForms.exe"

  s.files         = `git ls-files`.split("\n") + externals
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency("ffi", "~> 1.15.0")
  s.add_development_dependency("rspec", "~> 3.9")
  s.add_development_dependency("rake", "~> 10.5")
  s.add_development_dependency("yard", "~> 0.9")
  s.add_development_dependency("redcarpet", "~> 3.5")
  s.add_development_dependency("github-markup", "~> 3.0")
end
