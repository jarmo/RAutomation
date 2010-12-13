module RAutomation
  module Adapter
    module Ffi
      class Button
        include WaitHelper

        # Possible locators are :value, :id, :class and :index.
        def initialize(window, locators)
          @window = window
          @locators = locators
        end

        def click #:nodoc:
          clicked = false
          wait_until do
            @window.activate
            @window.active? &&
                    Functions.control_focus(hwnd) &&
                    Functions.control_click(hwnd) &&
                    clicked = true # is clicked at least once
            clicked && !exists?
          end
        end

        def value #:nodoc:
          Functions.control_text(hwnd)
        end

        def exists? #:nodoc:
          !!hwnd
        end

        private

        def hwnd
          Functions.control_hwnd(@window.hwnd, @locators)
        end
      end
    end
  end
end