module RAutomation
  module Adapter
    module MsUia
      module ButtonHelper

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
