module RAutomation
  module Implementations
    autoload :AutoIt, File.dirname(__FILE__) + "/autoit.rb"

    module Helper
      extend self

      # @private
      def default_implementation
        case RUBY_PLATFORM
          when /mswin|msys|mingw32/
            Implementations::AutoIt::Window
          else
            raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end
    end
  end
end