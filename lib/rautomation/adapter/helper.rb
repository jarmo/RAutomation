module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"
    autoload :MsUia, File.dirname(__FILE__) + "/ms_uia.rb"
    autoload :Win32, File.dirname(__FILE__) + "/win_32.rb"

    module Helper
      require 'fileutils'
      require File.expand_path('../../platform', __FILE__)
      extend self

      ADAPTER_DIRS = [
        "ext/IAccessibleDLL/Release/IAccessibleDLL.dll",
        "ext/UiaDll/Release/UiaDll.dll",
        "ext/UiaDll/Release/RAutomation.UIA.dll"
      ]

      # @private
      # Retrieves default {Adapter} for the current platform.
      def default_adapter
        if ENV['OS'] == 'Windows_NT'
          :win_32
        else
          raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end

      def supported_for_current_platform?(adapter)
        Platform.is_x86? || adapter == :win_32
      end

      def find_missing_externals
        ADAPTER_DIRS.select do |ext|
          path = "#{Dir.pwd}/#{File.dirname(ext)}"
          file = File.basename(ext)
          full_path = "#{path}/#{file}"
          !Dir.exist?(path) || !File.exist?(full_path)
        end
      end

      def build_solution(ext)
        return if File.exist?(ext)
        return if ext =~ /RAutomation.UIA.dll/ # skip this since its built in UiaDll.sln

        name = File.basename(ext, File.extname(ext))
        msbuild_solution(name)
      end

      def msbuild_solution(name)
        cmd = "msbuild /p:Configuration=Release ext\\#{name}\\#{name}.sln"
        cmd += " && #{cmd} /p:Platform=x64" unless name == 'WindowsForms'
        system(cmd) or raise StandardError, "An error occurred when trying to build solution #{name}. " +
                                            "Make sure msbuild binary is in your PATH and the project is configured correctly"
      end

      def move_adapter_dlls(ruby_platform)
        architecture = ruby_platform.split("-").first
        raise ArgumentError, "Invalid platform #{architecture}" unless %w[x86 x64].any? { |arch| arch == architecture }
        puts "Moving #{architecture} dll's into 'Release' folder.."

        ADAPTER_DIRS.each do |dest_path|
          dll_path = dest_path.gsub('Release', "#{architecture}Release")
          dest_dir = File.dirname(dest_path)
          FileUtils.mkdir_p(dest_dir) unless Dir.exist?(dest_dir)
          FileUtils.cp(dll_path, dest_path)
        end
      end
    end
  end
end
