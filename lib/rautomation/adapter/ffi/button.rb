module RAutomation
  module Adapter
    module Ffi
      class Button
        include WaitHelper
        include Locators

        # Possible locators are :value, :id, :class and :index.
        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        def click #:nodoc:
          clicked = false
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)
            @window.activate
            @window.active? &&
                    Functions.control_focus(hwnd) &&
                    Functions.control_click(hwnd) &&
                    clicked = true # is clicked at least once
            clicked && !exists?
          end
        end

        def value #:nodoc:
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def exists? #:nodoc:
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

      end
    end
  end
end