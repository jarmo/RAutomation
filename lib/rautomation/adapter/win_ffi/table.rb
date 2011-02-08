module RAutomation
  module Adapter
    module WinFfi
      class Table < Control
        include WaitHelper
        include Locators

        def strings
          rows = []

          (0..row_count).each do |row|
            puts "Asking for row #{row}"
            rows.push Functions.retrieve_table_strings_for_row(Functions.control_hwnd(@window.hwnd, @locators), row)
          end

          rows
        end

        def select(row)
          Functions.select_table_row(@window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
        end

        def selected?(row)
          state = Functions.get_table_row_state(@window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
          state & Constants::STATE_SYSTEM_SELECTED != 0
        end
        
        private

        def row_count
          Functions.send_message(Functions.control_hwnd(@window.hwnd, @locators), Constants::LVM_GETITEMCOUNT, 0, nil)
        end


      end
    end
  end
end

