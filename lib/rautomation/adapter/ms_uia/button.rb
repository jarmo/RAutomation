module RAutomation
  module Adapter
    module MsUia
      class Button < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /button/i}

        def exist?
          super && matches_type?(Constants::UIA_BUTTON_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?
        alias_method :value, :control_name

      end
    end
  end
end
