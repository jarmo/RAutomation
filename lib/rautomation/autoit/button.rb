module RAutomation
  module AutoIt
    class Button
      include WaitHelper

      def initialize(window, button_name)
        @window = window
        @name = button_name
      end

      # clicks specified button on window with specified title,
      # activates window automatically and makes sure that the click
      # was successful
      def click
        clicked = false
        wait_until do
          @window.activate &&
                  Window.autoit.ControlFocus(@window.locator, "", @name) == 1 &&
                  Window.autoit.ControlClick(@window.locator, "", @name) == 1 &&
                  clicked = true # is clicked at least once

          clicked && !exists?
        end
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