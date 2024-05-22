require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'
require File.expand_path('../lib/rautomation/adapter/helper', __FILE__)

Bundler::GemHelper.install_tasks

namespace :compile do
  compile_tasks = [
    {:name => :uia_dll, :path => "UiaDll", :ext => "dll"},
    {:name => :i_accessible_dll, :path => "IAccessibleDLL", :ext => "dll"},
    {:name => :windows_forms, :path => "WindowsForms", :ext => "exe"}
  ]

  compile_tasks.each do |compile_task|
    desc "Compile #{compile_task[:path]}"
    task compile_task[:name] do
      full_ext_path = "ext/#{compile_task[:path]}/Release/#{compile_task[:path]}.#{compile_task[:ext]}"
      %w[x86Release x64Release].each do |output_dir|
        full_ext_path = full_ext_path.gsub(/(?<!x86|x64)Release/, output_dir) unless compile_task[:name] == :windows_forms
        RAutomation::Adapter::Helper.build_solution(full_ext_path)
      end
    end
  end

  desc "Compile all external dependencies"
  task :all => compile_tasks.map { |t| "compile:#{t[:name]}"}
end

task :compile => "compile:all"

namespace :build do
  platforms = %w[x86-mingw32 x64-mingw32 x86-mingw-ucrt x64-mingw-ucrt]
  platforms.each do |platform|
    desc "Build gem for platform: #{platform}"
    task platform => "compile:all" do
      RAutomation::Adapter::Helper.move_adapter_dlls(platform)
      sh "gem build --platform #{platform}"
      mkdir_p 'pkg' unless Dir.exist?('pkg')
      mv Dir.glob("rautomation-*-#{platform}.gem"), 'pkg'
    end
  end

  desc "Build gem for all platforms"
  task :all => platforms.map(&:to_sym)
end

task :build => 'build:all'

namespace :spec do
  adapters = %w[win_32]
  adapters << "ms_uia" if %w[x86 i386].any? { |p| RUBY_PLATFORM =~ /#{p}/i }

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
