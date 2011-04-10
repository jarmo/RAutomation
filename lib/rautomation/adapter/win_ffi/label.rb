module RAutomation
  module Adapter
    module WinFfi
      class Label < Control
        include WaitHelper
        include Locators

        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end
        
      end
    end
  end
end
