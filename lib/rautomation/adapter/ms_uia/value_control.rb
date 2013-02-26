module RAutomation
  module Adapter
    module MsUia
      class ValueControl < Control
        include WaitHelper
        include Locators

        def value
          UiaDll::get_control_value(hwnd)
        end

        def set(value)
          UiaDll::set_control_value(hwnd, value)
        end

        alias_method :exists?, :exist?
      end
    end
  end
end

