module RAutomation
  class Button
    def initialize(window, button_name)
      @window = window
      @name = button_name
      @button = @window.button(@name)
    end

    def click
      assert_exists
      @button.click
    end

    def value
      assert_exists
      @button.value
    end

    def exists?
      @button.exists?
    end

    alias_method :exist?, :exists?

    private

    def assert_exists
      raise UnknownButtonException.new("Button '#{@name}' doesn't exist on window '#{@window.locator}'!") unless exists?
    end
  end
end