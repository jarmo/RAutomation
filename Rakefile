require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

namespace :build do
  build_tasks = [
    {:name => :uia_dll, :path => "UiaDll"},
    {:name => :i_accessible_dll, :path => "IAccessibleDLL"},
    {:name => :windows_forms, :path => "WindowsForms"}
  ]

  build_tasks.each do |build_task|
    desc "Build #{build_task[:path]}"
    task build_task[:name] do
      sh "msbuild /property:Configuration=Release ext\\#{build_task[:path]}\\#{build_task[:path]}.sln"
    end
  end

  desc "Build all external dependencies"
  task :all => build_tasks.map { |t| "build:#{t[:name]}"}
end

task :build => "build:all"

namespace :spec do
  adapters = %w[win_32 autoit ms_uia]

  adapters.each do |adapter|
    desc "Run RSpec code examples against #{adapter} adapter"
    task adapter do
      ENV["RAUTOMATION_ADAPTER"] = adapter
      puts "Running specs for adapter: #{adapter}"
      task = Rake::Task["spec"]
      task.reenable
      task.invoke      
    end
  end

  desc "Run RSpec code examples against all adapters"
  task :all => adapters.map {|a| "spec:#{a}"}
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :spec => :build

RSpec::Core::RakeTask.new(:rcov) { |spec| spec.rcov = true }

require 'yard'
YARD::Rake::YardocTask.new

task :default => "spec:all"

task :release => "spec:all"

task :install => :build
