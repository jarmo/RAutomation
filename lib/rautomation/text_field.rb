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
      assert_exists
      @text_field.set(text)
    end

    # Clears TextField's text.
    #
    # Raises an UnknownTextFieldException if the TextField itself doesn't exist.
    def clear
      assert_exists
      @text_field.clear
    end

    # Returns TextField's text.
    #
    # Raises an UnknownTextFieldException if the TextField itself doesn't exist.
    def value
      assert_exists
      @text_field.value
    end

    # Returns true if TextField exists, false otherwise.
    def exists?
      @text_field.exists?
    end

    alias_method :exist?, :exists?

    private

    def assert_exists
      raise UnknownTextFieldException.new("Text field '#{@locators.inspect}' doesn't exist on window '#{@window.locators.inspect}'!") unless exists?
    end
  end
end