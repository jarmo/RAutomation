module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"
    autoload :MsUia, File.dirname(__FILE__) + "/ms_uia.rb"
    autoload :Win32, File.dirname(__FILE__) + "/win_32.rb"

    module Helper
      require 'fileutils'
      require File.expand_path('../../platform', __FILE__)
      extend self

      # @private
      # Retrieves default {Adapter} for the current platform.
      def default_adapter
        if ENV['OS'] == 'Windows_NT'
          :win_32
        else
          raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end

      def find_missing_externals(externals)
        externals.select do |ext|
          path = "#{Dir.pwd}/#{File.dirname(ext)}"
          file = File.basename(ext)
          !Dir.exists?(path) && !File.exists?("#{path}/#{file}")
        end
      end

      def build_solution(ext, platform)
        name = File.basename(ext, File.extname(ext))
        cmd = "msbuild /p:Configuration=Release ext\\#{name}\\#{name}.sln"
        cmd += " && #{cmd} /p:Platform=x64" if platform =~ /x64/ && name != 'WindowsForms'
        system(cmd) or raise StandardError, "An error occurred when trying to build solution #{name}. " +
                                            "Make sure msbuild binary is in your PATH and the project is configured correctly"
      end

      def move_adapter_dlls(externals)
        architecture = Platform.architecture
        puts "Moving #{architecture} dll's into 'Release' folder.."

        externals.each do |dest_path|
          next if dest_path =~ /WindowsForms/
          dll_path = dest_path.gsub('Release', "#{architecture}Release")
          FileUtils.cp(dll_path, dest_path)
        end

        externals
      end
    end
  end
end
