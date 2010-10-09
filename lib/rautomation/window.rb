module RAutomation
  class UnknownWindowException < RuntimeError
  end
  class UnknownButtonException < RuntimeError
  end
  class UnknownTextFieldException < RuntimeError
  end

  class Window
    class << self
      # Sets implementation class, which is used for all interaction with the windows.
      def implementation=(impl)
        @@impl = impl
      end

      # Returns the implementation class, which is used for all interaction with the windows.
      def implementation
        @@impl
      end
    end

    # Creates a new Window object using the +locator+ Hash parameter.
    #
    # Possible parameters can depend of the used platform and implementation, but
    # following examples will use _:title_, _:class_ and _:hwnd_.
    #
    # Use window with _some title_ being part of it's title:
    #   RAutomation::Window.new(:title => "some title")
    #
    # Use window with Regexp title:
    #   RAutomation::Window.new(:title => /some title/i)
    #
    # Use window with handle _123456_:
    #   RAutomation::Window.new(:hwnd => 123456)
    #
    # It is possible to use multiple locators together where every locator will be matched (AND-ed) to the window:
    #   RAutomation::Window.new(:title => "some title", :class => "IEFrame")
    #
    # Refer to all possible locators in each implementation's documentation.
    #
    # Object creation doesn't check for window's existence.
    #
    # Only visible windows will be searched for initially.
    def initialize(locator)
      @window = @@impl.new(locator)
    end

    # Returns handle of the Window.
    #
    # This handle will be used internally for all operations.
    def hwnd
      assert_exists
      @window.hwnd
    end

    # Returns title of the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def title
      assert_exists
      @window.title
    end

    # Activates the Window, e.g. brings to the top.
    def activate
      @window.activate
    end

    # Returns true if the Window is active, false otherwise.
    def active?
      @window.active?
    end

    # Returns visible text of the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def text
      assert_exists
      @window.text
    end

    # Returns true if the Window exists, false otherwise.
    def exists?
      @window.exists?
    end

    alias_method :exist?, :exists?

    # Returns true if the Window is visible, false otherwise.
    # Window is also visible, if it is behind other windows.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def visible?
      assert_exists
      @window.visible?
    end

    # Returns true if the Window exists and is visible, false otherwise.
    def present?
      exists? && visible?
    end

    # Maximizes the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def maximize
      assert_exists
      @window.maximize
    end

    # Minimizes the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def minimize
      assert_exists
      @window.minimize
    end

    # Sends keys to the Window. Refer to specific implementation's documentation for possible values.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def send_keys(keys)
      assert_exists
      @window.send_keys(keys)
    end

    # Closes the Window if it exists.
    def close
      return unless @window.exists?
      @window.close
    end

    # Returns the Button object by the _locator_ on the Window.
    # Refer to specific implementation's documentation for possible parameters.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def button(locator)
      assert_exists
      Button.new(@window, locator)
    end

    # Returns the TextField object by the _locator_ on the Window.
    # Refer to specific implementation's documentation for possible parameters.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def text_field(locator)
      assert_exists
      TextField.new(@window, locator)
    end

    private

    def assert_exists
      raise UnknownWindowException.new("Window with locator '#{@window.locator}' doesn't exist!") unless exists?
    end
  end
end