module RAutomation
  module Adapter
    module MsUia
      class Label < Control
        include WaitHelper
        include Locators

        #todo - replace with UIA version
        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def exist?
          super && matches_type?(Constants::UIA_TEXT_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
