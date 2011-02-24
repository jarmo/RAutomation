module RAutomation
  module Adapter
    module WinFfi
      class Button < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /button/i}

        # @see RAutomation::Button#value
        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def has_focus?
          Functions.has_focus?(Functions.control_hwnd(@window.hwnd, @locators))
        end

      end
    end
  end
end
