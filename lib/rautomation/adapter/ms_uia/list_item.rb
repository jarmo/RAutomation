module RAutomation
  module Adapter
    module MsUia
      class ListItem < Control
        include WaitHelper
        include Locators

        def value
          list_item = uia_element
#          hwnd = Functions.control_hwnd(@window.hwnd, @locators)
#          checkbox = UiaDll::element_from_handle(hwnd)

          item_value = FFI::MemoryPointer.new :char, UiaDll::get_name(list_item, nil) + 1
          UiaDll::get_name(list_item, item_value)
          item_value.read_string
        end

        def exist?
          super && matches_type?(Constants::UIA_LIST_ITEM_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
