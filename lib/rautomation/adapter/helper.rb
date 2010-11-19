module RAutomation
  module Adapter
    autoload :Autoit, File.dirname(__FILE__) + "/autoit.rb"

    module Helper
      extend self

      # @private
      def default_adapter
        case RUBY_PLATFORM
          when /mswin|msys|mingw32/
            Adapter::Autoit::Window
          else
            raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
        end
      end
    end
  end
end