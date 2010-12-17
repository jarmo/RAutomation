module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"
    autoload :Ffi, File.dirname(__FILE__) + "/ffi.rb"

    module Helper
      extend self

      # @private
      # Retrieves default {Adapter} for the current platform.
      def default_adapter
        case RUBY_PLATFORM
          when /mswin|msys|mingw32/
            :ffi
          else
            raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end
    end
  end
end