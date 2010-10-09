module RAutomation
  module AutoIt
    class Button
      include WaitHelper
      include Locators

      # Special-cased locators
      LOCATORS = {:class_name => :classnn}

      # Possible locators are _:text_, _:id_, _:class_, _:class_name_ and _:instance_.
      def initialize(window, locators)
        @window = window
        extract(locators)
      end

      def click #:nodoc:
        clicked = false
        wait_until do
          @window.activate
          @window.active? &&
                  Window.autoit.ControlFocus(@window.locator_hwnd, "", @locators) == 1 &&
                  Window.autoit.ControlClick(@window.locator_hwnd, "", @locators) == 1 &&
                  clicked = true # is clicked at least once

          clicked && !exists?
        end
      end

      def value #:nodoc:
        Window.autoit.ControlGetText(@window.locator_hwnd, "", @locators)
      end

      def exists? #:nodoc:
        not Window.autoit.ControlGetHandle(@window.locator_hwnd, "", @locators).empty?
      end
    end
  end
end