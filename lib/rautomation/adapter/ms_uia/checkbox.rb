module RAutomation
  module Adapter
    module MsUia
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

        def exist?
          super && matches_type?(Constants::UIA_CHECKBOX_CONTROL_TYPE)
        end

        def set?
          UiaDll::is_set(search_information)
        end

        alias_method :exists?, :exist?
        alias_method :value, :control_name

      end
    end
  end
end
