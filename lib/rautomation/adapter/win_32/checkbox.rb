module RAutomation
  module Adapter
    module Win32
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

      end
    end
  end
end
