module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"
    autoload :MsUia, File.dirname(__FILE__) + "/ms_uia.rb"
    autoload :Win32, File.dirname(__FILE__) + "/win_32.rb"

    module Helper
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

      def move_adapter_dlls(externals)
        puts "Using #{Platform.architecture} externals"

        externals.each do |dest_path|
          dll_path = dest_path.gsub('Release', "#{Platform.architecture}Release")
          next if File.exists?(dest_path)
          FileUtils.cp(dll_path, dest_path)
        end

        externals
      end
    end
  end
end
