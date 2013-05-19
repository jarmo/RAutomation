require 'rubygems'
require 'bundler'

Bundler::GemHelper.install_tasks

def ext_dependencies(name)
  FileList["ext/#{name}/**/*"].reject { |file| file =~ /\b(Release|Debug)\b/ }
end

def ms_build(name)
  name = File.basename(name, File.extname(name))
  sh "msbuild /property:Configuration=Release ext\\#{name}\\#{name}.sln"
end

namespace :build do
  build_tasks = [
    {:name => :uia_dll, :path => "UiaDll", :ext => "dll"},
    {:name => :i_accessible_dll, :path => "IAccessibleDLL", :ext => "dll"},
    {:name => :windows_forms, :path => "WindowsForms", :ext => "exe"}
  ]

  build_tasks.each do |build_task|
    full_ext_path = "ext/#{build_task[:path]}/Release/#{build_task[:path]}.#{build_task[:ext]}"

    file full_ext_path => ext_dependencies(build_task[:path]) do |t|
      ms_build t.name
    end

    desc "Build #{build_task[:path]}"
    task build_task[:name] => full_ext_path
  end

  desc "Build all external dependencies"
  task :all => build_tasks.map { |t| "build:#{t[:name]}"}
end

task :build => "build:all"

namespace :spec do
  adapters = %w[win_32 ms_uia]

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
