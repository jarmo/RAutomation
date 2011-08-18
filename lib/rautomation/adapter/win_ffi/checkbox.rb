module RAutomation
  module Adapter
    module WinFfi
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

        def value
          hwnd = Functions.control_hwnd(@window.hwnd, @locators)
          checkbox = UiaDll::element_from_handle(hwnd)

          checkbox_value = FFI::MemoryPointer.new :char, UiaDll::get_name(checkbox, nil) + 1
          UiaDll::get_name(checkbox, checkbox_value)
          checkbox_value.read_string
        end

        def exist?
          super && matches_type?(Constants::UIA_CHECKBOX_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
