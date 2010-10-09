module RAutomation
  class Button
    # This constructor is meant to be accessed only through RAutomation::Window#button method.
    def initialize(window, locator) #:nodoc:
      @window = window
      @locator = locator
      @button = @window.button(@locator)
    end

    # Performs a click on the Button.
    #
    # Raises an UnknownButtonException if the Button itself doesn't exist.
    def click
      assert_exists
      @button.click
    end

    # Retrieves the value of the Button, usually the visible text.
    #
    # Raises an UnknownButtonException if the Button itself doesn't exist.
    def value
      assert_exists
      @button.value
    end

    # Returns true if Button exists, false otherwise.
    def exists?
      @button.exists?
    end

    alias_method :exist?, :exists?

    private

    def assert_exists
      raise UnknownButtonException.new("Button '#{@locator}' doesn't exist on window '#{@window.locator}'!") unless exists?
    end
  end
end