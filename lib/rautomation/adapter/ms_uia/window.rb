module RAutomation
  module Adapter
    module MsUiAutomation
      class Window
        include Locators

        def initialize(locators)
          extract(locators)
          @iuiautomation_ptr = nil
        end

        def exists?
          @iuiautomation_ptr = UiaDll.find_window(@automation_id)
          !@iuiautomation_ptr.null?
        end

        def visible?
          !UiaDll.is_offscreen(@iuiautomation_ptr)
        end
      end
    end
  end
end
