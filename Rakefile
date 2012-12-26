require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

namespace :build do
  desc "Build UiaDll"
  task :uia_dll do
    sh "msbuild /property:Configuration=Release ext\\UiaDll\\UiaDll.sln"
  end

  desc "Build IAccessibleDLL"
  task :i_accessible_dll do
    sh "msbuild /property:Configuration=Release ext\\IAccessibleDLL\\IAccessibleDLL.sln"
  end

  desc "Build ListViewExplorer"
  task :list_view_explorer do
    sh "msbuild /property:Configuration=Release ext\\ListViewExplorer\\ListViewExplorer.sln"
  end

  desc "Build WindowsForms"
  task :windows_forms do
    sh "msbuild /property:Configuration=Release ext\\WindowsForms\\WindowsForms.sln"
  end

  desc "Build all external dependencies"
  task :all => %w[build:uia_dll build:i_accessible_dll build:list_view_explorer build:windows_forms]
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
