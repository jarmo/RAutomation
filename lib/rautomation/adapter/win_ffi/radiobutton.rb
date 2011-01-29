module RAutomation
  module Adapter
    module WinFfi
      class RadioButton < Control
        include WaitHelper
        include Locators
        include ButtonHelper

      end
    end
  end
end
