module RAutomation
  module Implementations
    module Helper
      extend self

      # @private
      def default_implementation
        case RUBY_PLATFORM
          when /mswin|msys|mingw32/
            require_rel "autoit.rb"
            Implementations::AutoIt::Window
          else
            raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end
    end
  end
end