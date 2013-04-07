module RAutomation
  module Adapter
    module MsUia
      class Label < Control
        include WaitHelper
        include Locators

        def exist?
          super && matches_type?(Constants::UIA_TEXT_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?
        alias_method :value, :control_name

      end
    end
  end
end
