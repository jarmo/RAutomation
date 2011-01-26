module RAutomation
  module Adapter
    module WinFfi
      class Checkbox < Control
        include WaitHelper
        include Locators
        include ButtonHelper

      end
    end
  end
end
