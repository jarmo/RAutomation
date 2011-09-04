require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rautomation"
    gem.summary = %Q{Automate windows and their controls through user-friendly API with Ruby}
    gem.description = %Q{RAutomation is a small and easy to use library for helping out to automate windows and their controls
for automated testing.

RAutomation provides:
* Easy to use and user-friendly API (inspired by Watir http://www.watir.com)
* Cross-platform compatibility
* Easy extensibility - with small scripting effort it's possible to add support for not yet
  supported platforms or technologies}
    gem.email = "jarmo.p@gmail.com"
    gem.homepage = "http://github.com/jarmo/RAutomation"
    gem.authors = ["Jarmo Pertman"]
    gem.add_development_dependency "rspec", "~>2.3"

    ignored_files = []
    ignored_files << ".gitignore" << ".gemspec" << "features" << "IAccessibleDLL.sdf"
    gem.files = `git ls-files`.strip.split($/).delete_if {|f| f =~ Regexp.union(*ignored_files)}
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


task :default => "spec:all"

namespace :spec do
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rcov = true
  end

  task :spec => :check_dependencies

  adapters = %w[win_32 autoit]
  adapters.each do |adapter|
    desc "Run specs against #{adapter} adapter"
    task adapter do
      ENV["RAUTOMATION_ADAPTER"] = adapter
      puts "Running specs for adapter: #{adapter}"
      task = Rake::Task["spec:spec"]
      task.reenable
      task.invoke      
    end
  end

  desc "Run specs against all adapters"
  task :all => adapters.map {|a| "spec:#{a}"}
end

require 'yard'
YARD::Rake::YardocTask.new
