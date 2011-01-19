module RAutomation
  module Adapter
    module WinFfi
      class Checkbox
        include WaitHelper
        include Locators

        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        def exists?
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

        # TODO: not DRY, copied from button#click
        def click
          clicked = false
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)

            @window.activate
            @window.active? &&
                    Functions.set_control_focus(hwnd) &&
                    Functions.control_click(hwnd) &&
                    clicked = true # is clicked at least once

            block_given? ? yield : clicked && exists?
          end
        end

        def set?
          control_hwnd = Functions.control_hwnd(@window.hwnd, @locators)

          if (@window.ms_accessibility_available?)
            Functions.checked? control_hwnd
          else
            fail "Using Win32 not yet implemented"
          end
        end

        # TODO call a windows function to do this without clicking
        def clear
          click if set? == true
        end

        # TODO call a windows function to do this without clicking
        def set(state_checked)
          click if state_checked == true
          clear if state_checked == false
        end

        alias_method :exist?, :exists?
        alias_method :checked?, :set?

      end
    end
  end
end
