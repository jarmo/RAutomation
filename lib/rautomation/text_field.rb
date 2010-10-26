module RAutomation
  class TextField
    # This constructor is meant to be accessed only through RAutomation::Window#text_field method.
    def initialize(window, locators) #:nodoc:
      @window = window
      @locators = locators
      @text_field = @window.text_field(@locators)
    end

    # Sets TextField's text to +text+.
    #
    # Raises an UnknownTextFieldException if the TextField itself doesn't exist.
    def set(text)
      wait_until_exists
      @text_field.set(text)
    end

    # Clears TextField's text.
    #
    # Raises an UnknownTextFieldException if the TextField itself doesn't exist.
    def clear
      wait_until_exists
      @text_field.clear
    end

    # Returns TextField's text.
    #
    # Raises an UnknownTextFieldException if the TextField itself doesn't exist.
    def value
      wait_until_exists
      @text_field.value
    end

    # Returns true if TextField exists, false otherwise.
    def exists?
      @text_field.exists?
    end

    alias_method :exist?, :exists?

    private

    def wait_until_exists
      WaitHelper.wait_until(RAutomation::Window.wait_timeout) {exists?}
    rescue WaitHelper::TimeoutError
      raise UnknownTextFieldException.new("Text field #{@locators.inspect} doesn't exist on window #{@window.locators.inspect}!") unless exists?
    end
  end
end