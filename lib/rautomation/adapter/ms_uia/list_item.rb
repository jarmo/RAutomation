module RAutomation
  module Adapter
    module WinFfi
      class ListItem < Control
        include WaitHelper
        include Locators

        def exist?
          super && matches_type?(Constants::UIA_LIST_ITEM_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
