module RAutomation
  module Adapter
    module MsUia
      class ListItem < Control
        include WaitHelper
        include Locators

        #Can't get by value without a handle or a bug fix in the new way of getting a control by value so this is a workaround
        def uia_element
          if @locators[:value]
            uia_window = UiaDll::element_from_handle(@window.hwnd)
            begin
              uia_window.read_pointer
            rescue FFI::NullPointerError => e
              raise UnknownElementException, "Window with handle #{@window.hwnd} does not exist"
            end
            uia_control = UiaDll::find_child_by_name(uia_window, @locators[:value].to_s)
            begin
              uia_control.read_pointer
            rescue FFI::NullPointerError => e
              raise UnknownElementException, "#{@locators[:value]} does not exist"
            end
            uia_control
          else
            super
          end
        end

        def value
          list_item = uia_element
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
