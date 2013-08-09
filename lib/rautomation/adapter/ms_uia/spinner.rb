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

        def minimum
          UiaDll::spinner_min(search_information)
        end

        def maximum
          UiaDll::spinner_max(search_information)
        end

        def increment
          UiaDll::increment_spinner(search_information)
        end

        def decrement
          UiaDll::decrement_spinner(search_information)
        end
      end
    end
  end
end
