module RAutomation
  module Adapter
    module MsUia
      module ButtonHelper

        #todo - replace with UIA version
        def set?
          control_hwnd = Functions.control_hwnd(@window.hwnd, @locators)
          Functions.control_set? control_hwnd
        end

        # @todo call a windows function to do this without clicking
        def clear
          click {!set?} if set?
        end

        # @todo call a windows function to do this without clicking
        def set
          click {set?} unless set?
        end

      end
    end
  end
end
