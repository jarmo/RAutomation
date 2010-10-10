module RAutomation
  class Button
    # This constructor is meant to be accessed only through RAutomation::Window#button method.
    def initialize(window, locators) #:nodoc:
      @window = window
      @locators = locators
      @button = @window.button(@locators)
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
      raise UnknownButtonException.new("Button '#{@locators.inspect}' doesn't exist on window '#{@window.locators.inspect}'!") unless exists?
    end
  end
end