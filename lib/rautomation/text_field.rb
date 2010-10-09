module RAutomation
  class TextField
    # This constructor is meant to be accessed only through RAutomation::Window#text_field method.
    def initialize(window, locator) #:nodoc:
      @window = window
      @locator = locator
      @text_field = @window.text_field(@locator)
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
      raise UnknownTextFieldException.new("Text field '#{@locator}' doesn't exist on window '#{@window.locator}'!") unless exists?
    end
  end
end