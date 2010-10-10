module RAutomation
  module ImplementationHelper
    extend self
    
    # @private
    def default_implementation
      case RUBY_PLATFORM
        when /mswin|msys|mingw32/
          require_rel "autoit.rb"
          AutoIt::Window
        else
          raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
      end
    end
  end
end