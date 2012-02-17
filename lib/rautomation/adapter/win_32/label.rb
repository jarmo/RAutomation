module RAutomation
  module Adapter
    module Win32
      class Label < Control
        include WaitHelper
        include Locators
      end
    end
  end
end
