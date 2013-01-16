module RAutomation
  module Adapter
    module Win32
      # @private
      module Functions
        extend FFI::Library

        ffi_lib 'user32', 'kernel32', 'ole32', File.dirname(__FILE__) + '/../../../../ext/IAccessibleDLL/Release/iaccessibleDll.dll'
        ffi_convention :stdcall

        callback :enum_callback, [:long, :pointer], :bool

        # user32
        attach_function :_get_window_rect, :GetWindowRect,
                        [:long, :pointer], :bool
        attach_function :_move_window, :MoveWindow,
                        [:long, :int, :int, :int, :int, :bool], :bool
        attach_function :enum_windows, :EnumWindows,
                        [:enum_callback, :pointer], :long
        attach_function :enum_child_windows, :EnumChildWindows,
                        [:long, :enum_callback, :pointer], :long
        attach_function :_close_window, :CloseWindow,
                        [:long], :bool
        attach_function :minimized, :IsIconic,
                        [:long], :bool
        attach_function :_window_title, :GetWindowTextA,
                        [:long, :pointer, :int], :int
        attach_function :window_title_length, :GetWindowTextLengthA,
                        [:long], :int
        attach_function :window_exists, :IsWindow,
                        [:long], :bool
        attach_function :_window_class, :GetClassNameA,
                        [:long, :pointer, :int], :int
        attach_function :window_visible, :IsWindowVisible,
                        [:long], :bool
        attach_function :show_window, :ShowWindow,
                        [:long, :int], :bool
        attach_function :send_message, :SendMessageA,
                        [:long, :uint, :uint, :pointer], :long
        attach_function :send_message_timeout, :SendMessageTimeoutA,
                        [:long, :uint, :uint, :pointer, :uint, :uint, :pointer], :bool
        attach_function :post_message, :PostMessageA,
                        [:long, :uint, :uint, :pointer], :bool
        attach_function :window_thread_process_id, :GetWindowThreadProcessId,
                        [:long, :pointer], :long
        attach_function :attach_thread_input, :AttachThreadInput,
                        [:long, :long, :bool], :bool
        attach_function :set_foreground_window, :SetForegroundWindow,
                        [:long], :bool
        attach_function :bring_window_to_top, :BringWindowToTop,
                        [:long], :bool
        attach_function :set_active_window, :SetActiveWindow,
                        [:long], :long
        attach_function :foreground_window, :GetForegroundWindow,
                        [], :long
        attach_function :send_key, :keybd_event,
                        [:uchar, :uchar, :int, :pointer], :void
        attach_function :control_id, :GetDlgCtrlID,
                        [:long], :int
        attach_function :_set_control_focus, :SetFocus,
                        [:long], :long
        attach_function :get_window, :GetWindow,
                        [:long, :uint], :long
        attach_function :get_last_error, :GetLastError,
                        [], :long
        attach_function :send_input, :SendInput,
                        [:uint, :pointer, :int], :int
        attach_function :_get_cursor_pos, :GetCursorPos,
                        [:pointer], :bool
        attach_function :set_cursor_pos, :SetCursorPos,
                        [:int, :int], :int

        # kernel32
        attach_function :current_thread_id, :GetCurrentThreadId,
                        [], :long
        attach_function :open_process, :OpenProcess,
                        [:int, :bool, :int], :long
        attach_function :terminate_process, :TerminateProcess,
                        [:long, :uint], :bool
        attach_function :close_handle, :CloseHandle,
                        [:long], :bool
        attach_function :load_library, :LoadLibraryA,
                        [:string], :long

        # ole32
        attach_function :co_initialize, :CoInitialize,
                        [:pointer], :uint16

        # iaccessible
        attach_function :get_button_state, :get_button_state,
                        [:long], :long
        attach_function :get_table_row_strings, :get_table_row_strings,
                        [:long, :long, :pointer, :long, :pointer], :void
        attach_function :select_table_row, :select_table_row,
                        [:long, :long, :long], :void
        attach_function :get_table_row_state, :get_table_row_state,
                        [:long, :long, :long], :long

        class << self

          def window_title(hwnd)
            title_length = window_title_length(hwnd) + 1
            title = FFI::MemoryPointer.new :char, title_length
            _window_title(hwnd, title, title_length)
            title.read_string
          end

          alias_method :control_title, :window_title

          def move_window(hwnd, x, y, width, height)
            _move_window(hwnd, x, y, width, height, true)
          end

          def get_cursor_pos
            ptr = FFI::MemoryPointer.new(:long, 2)
            _get_cursor_pos(ptr)
            x, y = ptr.read_array_of_long(2)
            return {:x => x, :y => y}
          end

          def window_rect(hwnd)
            x = FFI::MemoryPointer.new(:long, 4)
            _get_window_rect(hwnd, x)
            x.read_array_of_long(4)
          end

          def window_text(hwnd)
            found_text = []
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |child_hwnd, _|
              found_text << text_for(child_hwnd)
              true
            end
            enum_child_windows(hwnd, window_callback, nil)
            found_text.join(" ")
          end

          alias_method :control_text, :window_text

          def window_hwnd(locators)
            find_hwnd(locators) do |hwnd|
              window_visible(hwnd) && locators_match?(locators, window_properties(hwnd, locators))
            end
          end

          def child_window_locators(parent_hwnd, locators)
            child_hwnd = locators[:hwnd] || child_hwnd(parent_hwnd, locators)
            if child_hwnd
              locators.merge!(:hwnd => child_hwnd)
            else
              popup_hwnd = get_window(parent_hwnd, Constants::GW_ENABLEDPOPUP)
              if popup_hwnd != parent_hwnd
                popup_properties = window_properties(popup_hwnd, locators)
                locators.merge!(:hwnd => popup_hwnd) if locators_match?(locators, popup_properties)
              end
            end
            locators
          end

          def window_pid(hwnd)
            pid = FFI::MemoryPointer.new :int
            window_thread_process_id(hwnd, pid)
            pid.read_int
          end

          def window_class(hwnd)
            class_name = FFI::MemoryPointer.new :char, 512
            _window_class(hwnd, class_name, 512)
            class_name.read_string
          end

          alias_method :control_class, :window_class

          def close_window(hwnd)
            _close_window(hwnd)
            closed = send_message_timeout(hwnd, Constants::WM_CLOSE,
                                          0, nil, Constants::SMTO_ABORTIFHUNG, 1000, nil)
            # force it to close
            unless closed
              process_hwnd = open_process(Constants::PROCESS_ALL_ACCESS, false, window_pid(hwnd))
              terminate_process(process_hwnd, 0)
              close_handle(process_hwnd)
            end
          end

          def activate_window(hwnd)
            set_foreground_window(hwnd)
            set_active_window(hwnd)
            bring_window_to_top(hwnd)
            within_foreground_thread(hwnd) do
              set_foreground_window(hwnd)
              set_active_window(hwnd)
              bring_window_to_top(hwnd)
            end
          end

          alias_method :activate_control, :activate_window

          def control_hwnd(window_hwnd, locators)
            find_hwnd(locators, window_hwnd) do |hwnd|
              locators_match?(locators, control_properties(hwnd, locators))
            end
          end

          alias_method :child_hwnd, :control_hwnd

          def control_value(control_hwnd)
            text_for(control_hwnd)
          end

          def control_click(control_hwnd)
            post_message(control_hwnd, Constants::BM_CLICK, 0, nil)
          end

          def set_control_focus(control_hwnd)
            within_foreground_thread control_hwnd do
              _set_control_focus(control_hwnd)
            end
          end

          def set_control_text(control_hwnd, text)
            send_message(control_hwnd, Constants::WM_SETTEXT, 0, text)
          end

          def control_set?(control_hwnd)
            get_button_state(control_hwnd) & Constants::STATE_SYSTEM_CHECKED != 0
          end

          def has_focus?(control_hwnd)
            get_button_state(control_hwnd) & Constants::STATE_SYSTEM_FOCUSED != 0
          end

          def unavailable?(control_hwnd)
            get_button_state(control_hwnd) & Constants::STATE_SYSTEM_UNAVAILABLE != 0
          end

          def retrieve_combobox_item_text(control_hwnd, item_no)
            text_len = send_message(control_hwnd, Constants::CB_GETLBTEXTLEN, item_no, nil)

            string_buffer = FFI::MemoryPointer.new :char, text_len
            send_message(control_hwnd, Constants::CB_GETLBTEXT, item_no, string_buffer)
            string_buffer.read_string
          end

          private

          def within_foreground_thread(hwnd)
            foreground_thread = current_thread_id
            other_thread = window_thread_process_id(hwnd, nil)
            attach_thread_input(foreground_thread, other_thread, true) unless other_thread == foreground_thread
            yield
          ensure
            attach_thread_input(foreground_thread, other_thread, false) unless other_thread == foreground_thread
          end

          def window_properties(hwnd, locators)
            element_properties(:window, hwnd, locators)
          end

          def control_properties(hwnd, locators)
            element_properties(:control, hwnd, locators)
          end

          def element_properties(type, hwnd, locators)
            locators.inject({}) do |properties, locator|
              properties[locator[0]] = self.send("#{type}_#{locator[0]}", hwnd) unless locator[0] == :index
              properties
            end
          end

          def locators_match?(locators, properties)
            locators.all? do |locator, value|
              locator == :index or
                value.is_a?(Regexp) ? properties[locator] =~ value : properties[locator] == value
            end
          end

          def find_hwnd(locators, window_hwnd = nil)
            found_hwnd = nil
            found_index = -1
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |hwnd, _|
              if yield(hwnd)
                found_index += 1

                if locators[:index]
                  found_hwnd = hwnd if locators[:index] == found_index
                else
                  found_hwnd = hwnd
                end
              end
              !found_hwnd
            end

            unless window_hwnd
              enum_windows(window_callback, nil)
            else
              enum_child_windows(window_hwnd, window_callback, nil)
            end

            found_hwnd
          end

          def text_for(hwnd)
            text_length = send_message(hwnd, Constants::WM_GETTEXTLENGTH, 0, nil) + 1
            text = FFI::MemoryPointer.new :char, text_length
            send_message(hwnd, Constants::WM_GETTEXT, text_length, text)
            text.read_string
          end

        end
      end
    end
  end
end

