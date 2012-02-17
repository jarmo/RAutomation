module RAutomation
  module Adapter
    module Win32
      class Button < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /button/i}

      end
    end
  end
end
