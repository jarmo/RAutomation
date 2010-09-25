module RAutomation
  module AutoIt
    class TextField
      include WaitHelper

      def initialize(window, field_name)
        @window = window
        @name = field_name
      end

      # sets specified field's value on window with specified title,
      # activates window automatically and makes sure that the field's
      # value got changed
      def set(text)
        wait_until do
          @window.activate &&
                  Window.autoit.ControlFocus(@window.locator, "", @name) == 1 &&
                  Window.autoit.ControlSetText(@window.locator, "", @name, text) == 1 &&
                  value == text
        end
      end

      def clear
        set ""
      end

      def value
        Window.autoit.ControlGetText(@window.locator, "", @name)
      end

      def exists?
        not Window.autoit.ControlGetHandle(@window.locator, "", @name).empty?
      end
    end
  end
end