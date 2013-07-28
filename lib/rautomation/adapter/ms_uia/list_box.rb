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
          UiaDll::table_values(search_information).map do |list_item|
            @window.list_item(:value => list_item)
          end
        end

        def strings
          UiaDll::table_values(search_information)
        end

        def value
          UiaDll::selection search_information
        end

        def exist?
          super && matches_type?(Constants::UIA_LIST_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

        def selected?(index)
          item = items[index]
          return item && item.selected?
        end

        def select(index)
          UiaDll::select_list_select_index search_information, index
        end

      end
    end
  end
end

