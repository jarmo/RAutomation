module RAutomation
  module Adapter
    module MsUia
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

        def value
          checkbox = uia_element

          checkbox_value = FFI::MemoryPointer.new :char, UiaDll::get_name(checkbox, nil) + 1
          UiaDll::get_name(checkbox, checkbox_value)

          checkbox_value.read_string
        end

        def exist?
          super && matches_type?(Constants::UIA_CHECKBOX_CONTROL_TYPE)
        end

        def set?
          UiaDll::get_is_set(uia_element)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
