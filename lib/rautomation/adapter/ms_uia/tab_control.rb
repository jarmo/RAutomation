module RAutomation
  module Adapter
    module MsUia

      class TabControl < Control
        def items
          UiaDll::tab_items(search_information)
        end
      end

    end
  end
end
