module RAutomation
  class Button
    def initialize(window, button_name)
      @button = window.button(button_name)
    end

    def click
      @button.click
    end

    def value
      @button.value
    end

    def exists?
      @button.exists?
    end
  end
end