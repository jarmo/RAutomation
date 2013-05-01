module RAutomation
  module Adapter
    module MsUia
      class TextField < Control
        include WaitHelper
        include Locators

        # Default locators used for searching text fields.
        DEFAULT_LOCATORS = {:class => /edit/i}

        #todo - replace with UIA version
        # @see RAutomation::TextField#set
        def set(text)
          raise "Cannot set value on a disabled text field" if disabled?
          UiaDll::set_text(search_information, text)
        end

        # @see RAutomation::TextField#clear
        def clear
          raise "Cannot set value on a disabled text field" if disabled?
          set ""
        end

        #todo - replace with UIA version
        # @see RAutomation::TextField#value
        def value
          UiaDll::get_text(search_information)
        end

        def exist?
          super && matches_type?(Constants::UIA_EDIT_CONTROL_TYPE, Constants::UIA_DOCUMENT_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
