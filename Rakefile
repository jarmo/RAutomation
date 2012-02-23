require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
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

  adapters = %w[win_32 autoit ms_uia]
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
