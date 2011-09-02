module RAutomation
  module Adapter
    module MsUia
      class Radio < Control
        include WaitHelper
        include Locators
        include ButtonHelper


        def exist?
          super && matches_type?(Constants::UIA_RADIO_BUTTON_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
