module RAutomation
  module Adapter
    module Win32
      class Table < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /syslistview/i}

        def select(row)
          Functions.select_table_row(Window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
        end

        def selected?(row)
          state = Functions.get_table_row_state(Window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
          state & Constants::STATE_SYSTEM_SELECTED != 0
        end
      end
    end
  end
end
