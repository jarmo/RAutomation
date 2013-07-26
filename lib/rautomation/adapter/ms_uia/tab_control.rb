module RAutomation
  module Adapter
    module MsUia

      class TabControl < Control
        class TabItem
          attr_reader :text, :index

          def initialize(tab_control, text, index)
            @tab_control, @text, @index = tab_control, text, index
          end

          def select
            UiaDll::select_tab(@tab_control.search_information, index)
          end

          def selected?
            @index == UiaDll::tab_control_selected_index(@tab_control.search_information)
          end
        end

        def select(index)
          UiaDll::select_tab(search_information, index)
        end

        def set(value)
          UiaDll::select_tab(search_information, value)
        end

        def items
          values.each_with_index.map {|value, index| TabItem.new(self, value, index) }
        end

        def value
          UiaDll::tab_selection(search_information)
        end

        private
        def values
          UiaDll::tab_items(search_information)
        end
      end

    end
  end
end
