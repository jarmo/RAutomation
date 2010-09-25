module RAutomation
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

    def title
      @window.title
    end

    def activate
      @window.activate
    end

    def text
      @window.text
    end

    def exists?
      @window.exists?
    end

    def close
      @window.close
    end

    def button(name)
      Button.new(@window, name)
    end

    def text_field(name)
      TextField.new(@window, name)
    end
  end
end