require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rautomation"
    gem.summary = %Q{Automate windows and their controls through user-friendly API with Ruby}
    gem.description = %Q{RAutomation tries to be a small and easy to use library for helping out to automate windows and their controls
for automated testing.

RAutomation aims to provide:
* Easy to use and user-friendly API (inspired by Watir http://www.watir.com).
* Cross-platform compatibility
* Easy extensibility - have some application, which uses some specialized technology, but isn't supported by RAutomation?
  You can get dirty and create a new adapter for RAutomation!}
    gem.email = "jarmo.p@gmail.com"
    gem.homepage = "http://github.com/jarmo/RAutomation"
    gem.authors = ["Jarmo Pertman"]
    gem.add_development_dependency "rspec", "~>2.3"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "RAutomation #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
