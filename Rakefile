require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

def ext_dependencies(name)
  FileList["ext/#{name}/**/*"].reject { |file| file =~ /(Release|Debug)/ }
end

def ms_build(name)
  name = File.basename(name, File.extname(name))
  cmd = "msbuild /p:Configuration=Release ext\\#{name}\\#{name}.sln"
  cmd += " && #{cmd} /p:Platform=x64" unless name == 'WindowsForms'
  sh(cmd)
end

namespace :build do
  build_tasks = [
    {:name => :uia_dll, :path => "UiaDll", :ext => "dll"},
    {:name => :i_accessible_dll, :path => "IAccessibleDLL", :ext => "dll"},
    {:name => :windows_forms, :path => "WindowsForms", :ext => "exe"}
  ]

  build_tasks.each do |build_task|
    full_ext_path = "ext/#{build_task[:path]}/Release/#{build_task[:path]}.#{build_task[:ext]}"

    %w[x86Release x64Release].each do |output_dir|
      full_ext_path = full_ext_path.gsub(/(?<!x86|x64)Release/, output_dir) unless build_task[:name] == :windows_forms

      file full_ext_path => ext_dependencies(build_task[:path]) do |t|
        ms_build(t.name)
      end
    end

    desc "Build #{build_task[:path]}"
    task build_task[:name] => full_ext_path
  end

  desc "Build all external dependencies"
  task :all => build_tasks.map { |t| "build:#{t[:name]}"}
end

task :build => "build:all"

namespace :spec do
  adapters = %w[win_32]
  adapters << "ms_uia" if Platform.is_x86?

  adapters.each do |adapter|
    desc "Run RSpec code examples against #{adapter} adapter"
    RSpec::Core::RakeTask.new(adapter) do |_task|
      ENV["RAUTOMATION_ADAPTER"] = adapter
      puts "Running specs for adapter: #{adapter}"
    end
  end

  desc "Run RSpec code examples against all adapters"
  task :all => adapters.map {|a| "spec:#{a}"}
end

task :spec => "spec:all"

RSpec::Core::RakeTask.new(:rcov) { |spec| spec.rcov = true }

require 'yard'
YARD::Rake::YardocTask.new

task :default => "spec:all"

task "release:source_control_push" => :spec

task :install => :build
