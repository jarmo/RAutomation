module RAutomation
  class TextField
    def initialize(window, field_name)
      @text_field = window.text_field(field_name)
    end

    def set(text)
      @text_field.set(text)
    end

    def clear
      @text_field.clear
    end

    def value
      @text_field.value
    end

    def exists?
      @text_field.exists?
    end
  end
end