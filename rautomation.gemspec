# -*- encoding: utf-8 -*-
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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]  

  s.add_runtime_dependency("ffi")
  s.add_development_dependency("rspec", "~>2.3")
end

