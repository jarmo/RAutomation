module RAutomation
  module Adapter
    module WinFfi
      class Radio < Control
        include WaitHelper
        include Locators
        include ButtonHelper

      end
    end
  end
end
