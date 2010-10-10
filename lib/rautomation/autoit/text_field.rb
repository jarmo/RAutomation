module RAutomation
  module AutoIt
    class TextField
      include WaitHelper
      include Locators

      # Special-cased locators
      LOCATORS = {:class_name => :classnn}

      # Possible locators are :id, :class, :class_name and :instance.
      def initialize(window, locators)
        @window = window
        extract(locators)
      end

      def set(text) #:nodoc:
        wait_until do
          @window.activate
          @window.active? &&
                  Window.autoit.ControlFocus(@window.locator_hwnd, "", @locators) == 1 &&
                  Window.autoit.ControlSetText(@window.locator_hwnd, "", @locators, text) == 1 &&
                  value == text
        end
      end

      def clear #:nodoc:
        set ""
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