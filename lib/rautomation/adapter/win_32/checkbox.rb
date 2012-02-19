module RAutomation
  module Adapter
    module Win32
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

        DEFAULT_LOCATORS = {:class => /button/i}

      end
    end
  end
end
