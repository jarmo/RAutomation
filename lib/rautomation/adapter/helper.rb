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

      def move_adapter_dlls(externals, platform)
        architecture = Platform.architecture(platform)
        puts "Moving #{architecture} dll's into 'Release' folder.."

        externals.each do |dest_path|
          dll_path = dest_path.gsub('Release', "#{architecture}Release")
          FileUtils.cp(dll_path, dest_path)
        end

        externals
      end
    end
  end
end
