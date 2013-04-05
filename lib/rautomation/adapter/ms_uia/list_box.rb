module RAutomation
  module Adapter
    module MsUia

      class ListBox < Control
        include WaitHelper
        include Locators

        def count
          UiaDll::select_list_count search_information
        end

        def items
          UiaDll::find_table_values(@window.hwnd, @locators).map do |list_item|
            @window.list_item(:value => list_item)
          end
        end

        def strings
          items.collect { |item| item.value}
        end

        def value
          count.times do |index|
            if selected?(index)
              return strings[index]
            end
          end

          ""
        end

        def exist?
          super && matches_type?(Constants::UIA_LIST_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

        def selected?(index)
          if items[index]
            return items[index].selected?
          end

          false
        end

        def select(index)
          UiaDll::select_list_select_index search_information, index
        end

        def list_boundary
          boundary = FFI::MemoryPointer.new :long, 4

          Functions.send_message(hwnd, Constants::LB_GETITEMRECT, 0 ,boundary)

          boundary.read_array_of_long(4)
        end

        def get_top_index
          Functions.send_message(hwnd, Constants::LB_GETTOPINDEX, 0 ,nil)
        end

        def list_item_height
          Functions.send_message(hwnd, Constants::LB_GETITEMHEIGHT, 0 ,nil)
        end

        def scroll_to_item(row)
          Functions.send_message(hwnd, Constants::LB_SETTOPINDEX, row ,nil)
        end

      end
    end
  end
end

