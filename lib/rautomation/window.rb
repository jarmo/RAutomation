module RAutomation
  class UnknownWindowException < RuntimeError; end
  class UnknownButtonException < RuntimeError; end
  class UnknownTextFieldException < RuntimeError; end

  class Window
    class << self
      def implementation=(impl)
        @@impl = impl
      end

      def implementation
        @@impl
      end
    end

    def initialize(window_locator)
      @window = @@impl.new(window_locator)
    end

    def hwnd
      assert_exists
      @window.hwnd
    end

    def title
      assert_exists
      @window.title
    end

    def activate
      assert_exists
      @window.activate
    end

    def text
      assert_exists
      @window.text
    end

    def exists?
      @window.exists?
    end

    alias_method :exist?, :exists?

    def close
      return unless @window.exists?
      @window.close
    end

    def button(name)
      assert_exists
      Button.new(@window, name)
    end

    def text_field(name)
      assert_exists
      TextField.new(@window, name)
    end

    private

    def assert_exists
      raise UnknownWindowException.new("Window with locator '#{@window.locator}' doesn't exist!") unless exists?
    end
  end
end