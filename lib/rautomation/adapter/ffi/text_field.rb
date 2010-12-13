module RAutomation
  module Adapter
    module Ffi
      class TextField
        include WaitHelper
        include Locators

        # Possible locators are :id, :class and :index.
        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        def set(text) #:nodoc:
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)
            @window.activate
            @window.active? &&
                    Functions.control_focus(hwnd) &&
                    Functions.set_control_text(hwnd, text) &&
                    value == text
          end
        end

        def clear #:nodoc:
          set ""
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