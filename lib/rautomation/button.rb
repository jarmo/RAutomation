module RAutomation
  class Button
    # @private
    # This constructor is meant to be accessed only through {Window#button} method.
    def initialize(window, locators)
      @window = window
      @locators = locators
      @button = @window.button(@locators)
    end

    # Performs a click on the Button.
    # @raise [UnknownButtonException] if the button doesn't exist.
    def click
      wait_until_exists
      @button.click
    end

    # Retrieves the value (text) of the button, usually the visible text.
    # @return [String] the value (text) of the button.
    # @raise [UnknownButtonException] if the button doesn't exist.
    def value
      wait_until_exists
      @button.value
    end

    # Checks if the button exists.
    # @return [Boolean] true if button exists, false otherwise.
    def exists?
      @button.exists?
    end

    alias_method :exist?, :exists?

    private

    def wait_until_exists
      WaitHelper.wait_until(RAutomation::Window.wait_timeout) {exists?}
    rescue WaitHelper::TimeoutError
      raise UnknownButtonException, "Button #{@locators.inspect} doesn't exist on window #{@window.locators.inspect}!"
    end
  end
end