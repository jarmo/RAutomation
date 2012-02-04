module RAutomation
  module Adapter
    module MsUia
      class Button < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /button/i}

        #todo - replace with UIA version
        # @see RAutomation::Button#value
        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def exist?
          super && matches_type?(Constants::UIA_BUTTON_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
