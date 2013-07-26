module RAutomation
  module Adapter
    module MsUia

      class TabControl < Control
        class TabItem
          attr_reader :text, :index

          def initialize(text, index)
            @text, @index = text, index
          end
        end

        def items
          values.each_with_index.map(&TabItem.method(:new))
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
