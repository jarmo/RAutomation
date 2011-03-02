module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"
    autoload :WinFfi, File.dirname(__FILE__) + "/win_ffi.rb"
    autoload :MsUiAutomation, File.dirname(__FILE__) + "/ms_uia.rb"

    module Helper
      extend self

      # @private
      # Retrieves default {Adapter} for the current platform.
      def default_adapter
        case RUBY_PLATFORM
          when /mswin|msys|mingw32/
#            :win_ffi
            :ms_ui_automation
          else
            raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end
    end
  end
end