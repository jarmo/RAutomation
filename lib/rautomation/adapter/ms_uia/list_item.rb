module RAutomation
  module Adapter
    module MsUia
      class ListItem < Control
        include WaitHelper
        include Locators

        def exist?
          super && matches_type?(Constants::UIA_LIST_ITEM_CONTROL_TYPE)
        end

        def selected?
          UiaDll::is_selected(search_information)
        end

        alias_method :exists?, :exist?
        alias_method :value, :control_name

      end
    end
  end
end
