module RAutomation
  class TextField
    def initialize(window, field_name)
      @window = window
      @name = field_name
      @text_field = @window.text_field(@name)
    end

    def set(text)
      assert_exists
      @text_field.set(text)
    end

    def clear
      assert_exists
      @text_field.clear
    end

    def value
      assert_exists
      @text_field.value
    end

    def exists?
      @text_field.exists?
    end

    alias_method :exist?, :exists?

    private

    def assert_exists
      raise UnknownTextFieldException.new("Text field '#{@name}' doesn't exist on window '#{@window.locator}'!") unless exists?
    end
  end
end