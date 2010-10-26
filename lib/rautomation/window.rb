module RAutomation
  class UnknownWindowException < RuntimeError
  end
  class UnknownButtonException < RuntimeError
  end
  class UnknownTextFieldException < RuntimeError
  end

  class Window
    include Implementations::Helper

    attr_reader :implementation

    # Creates a new Window object using the _locators_ Hash parameter.
    #
    # Possible Window _locators_ may depend of the used platform and implementation, but
    # following examples will use :title, :class and :hwnd.
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
    # _locators_ may also include a key called :implementation to change default implementation,
    # which is dependent of the platform, to automate windows and their controls.
    #
    # It is also possible to change default implementation by using environment variable:
    # <em>RAUTOMATION_IMPLEMENTATION</em>
    #
    # * Object creation doesn't check for window's existence.
    # * Window to be searched for has to be visible!
    def initialize(locators)
      @implementation = locators.delete(:implementation) || ENV["RAUTOMATION_IMPLEMENTATION"] || default_implementation
      @window = @implementation.new(locators)
    end

    class << self
      @@wait_timeout = 60

      def wait_timeout=(timeout)
        @@wait_timeout = timeout
      end

      def wait_timeout
        @@wait_timeout
      end
    end

    # Returns handle of the Window.
    #
    # This handle will be used internally for all operations.
    def hwnd
      wait_until_exists
      @window.hwnd
    end

    # Returns title of the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def title
      wait_until_exists
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
      wait_until_exists
      @window.text
    end

    # Returns true if the Window exists, false otherwise.
    def exists?
      @window.exists?
    end

    alias_method :exist?, :exists?

    # Returns true if the Window is visible, false otherwise.
    # Window is also visible, if it is behind other windows or minimized.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def visible?
      wait_until_exists
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
      wait_until_exists
      @window.maximize
    end

    # Minimizes the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def minimize
      wait_until_exists
      @window.minimize
    end

    # Returns true if the Window is minimized, false otherwise.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def minimized?
      wait_until_exists
      @window.minimized?
    end

    # Restores the Window.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def restore
      wait_until_exists
      @window.restore
    end

    # Sends keys to the Window. Refer to specific implementation's documentation for possible values.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def send_keys(keys)
      wait_until_exists
      @window.send_keys(keys)
    end

    # Closes the Window if it exists.
    def close
      return unless @window.exists?
      @window.close
    end

    # Returns the Button object by the _locators_ on the Window.
    # Refer to specific implementation's documentation for possible parameters.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def button(locators)
      wait_until_exists
      Button.new(@window, locators)
    end

    # Returns the TextField object by the _locators_ on the Window.
    # Refer to specific implementation's documentation for possible parameters.
    #
    # Raises an UnknownWindowException if the Window itself doesn't exist.
    def text_field(locators)
      wait_until_exists
      TextField.new(@window, locators)
    end

    # Allow to execute implementation's methods not part of the public API
    def method_missing(name, *args)
      @window.respond_to?(name) ? @window.send(name, *args) : super
    end

    private

    def wait_until_exists
      WaitHelper.wait_until(RAutomation::Window.wait_timeout) {exists?}
    rescue WaitHelper::TimeoutError
      raise UnknownWindowException.new("Window with locator #{@window.locators.inspect} doesn't exist!") unless exists?
    end

  end
end