module RAutomation
  module Adapter
    module MsUia
      class Spinner < Control
        def set(value)
          UiaDll::set_spinner_value(search_information, value)
        end

        def value
          UiaDll::spinner_value(search_information)
        end
      end
    end
  end
end
