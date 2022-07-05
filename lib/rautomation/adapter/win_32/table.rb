module RAutomation
  module Adapter
    module Win32
      class Table < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /syslistview/i}

        def select(row)
          if Platform.is_x86?
            Functions.select_table_row(Window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
          else
            Functions.select_table_row_64(Window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
          end
        end

        def selected?(row)
          handle = Window.oleacc_module_handle
          control_hwnd = Functions.control_hwnd(@window.hwnd, @locators)

          state =
            if Platform.is_x86?
              Functions.get_table_row_state(handle, control_hwnd, row)
            else
              Functions.get_table_row_state_64(handle, control_hwnd, row)
            end

          state & Constants::STATE_SYSTEM_SELECTED != 0
        end
      end
    end
  end
end
