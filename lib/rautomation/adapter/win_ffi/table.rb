module RAutomation
  module Adapter
    module WinFfi
      class Table < Control
        include WaitHelper
        include Locators

        private

        def row_count
          Functions.send_message(Functions.control_hwnd(@window.hwnd, @locators), Constants::LVM_GETITEMCOUNT, 0, nil)
        end

      end
    end
  end
end

