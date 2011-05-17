module RAutomation
  module Adapter
    module WinFfi

      class ListBox < Control
        include WaitHelper
        include Locators

        def count
          UiaDll::find_children(uia_control(@locators[:id]), nil)
        end

        def items
          list_items = []
          children = FFI::MemoryPointer.new :pointer, self.count
          length = UiaDll::find_children(uia_control(@locators[:id]), children)
          children.read_array_of_pointer(length).each do |child|
            child_name = FFI::MemoryPointer.new :char, UiaDll::get_name(child, nil) + 1
            UiaDll::get_name(child, child_name)
            list_items.push child_name.read_string
          end
          list_items
        end

        def exist?
          @locators[:id].nil? ? super : super && matches_type(ListBox.class)
        end

        def matches_type(clazz)
          UiaDll::current_control_type(uia_control(@locators[:id])) == Constants::UIA_LIST_CONTROL_TYPE
        end

      end
    end
  end
end
