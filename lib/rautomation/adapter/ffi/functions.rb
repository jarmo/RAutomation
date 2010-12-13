module RAutomation
  module Adapter
    module Ffi
      module Functions
        extend FFI::Library

        ffi_lib 'user32', 'kernel32'
        ffi_convention :stdcall

        callback :enum_callback, [:long, :pointer], :bool

        # user32
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
        attach_function :control_focus, :SetFocus,
                        [:long], :long

        # kernel32
        attach_function :open_process, :OpenProcess,
                        [:int, :bool, :int], :long
        attach_function :terminate_process, :TerminateProcess,
                        [:long, :uint], :bool
        attach_function :close_handle, :CloseHandle,
                        [:long], :bool

        class << self
          def window_title(hwnd)
            title_length = window_title_length(hwnd) + 1
            title = FFI::MemoryPointer.new :char, title_length
            _window_title(hwnd, title, title_length)
            title.read_string
          end

          def window_text(hwnd)
            found_text = ""
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |child_hwnd, _|
              found_text << text_for(child_hwnd)
              true
            end
            enum_child_windows(hwnd, window_callback, nil)
            found_text
          end

          def window_hwnd(locators)
            find_hwnd(locators) do |hwnd|
              window_visible(hwnd) && !window_text(hwnd).empty? &&
                      locators_match?(locators, window_properties(hwnd, locators))
            end
          end

          def window_class(hwnd)
            class_name = FFI::MemoryPointer.new :char, 512
            _window_class(hwnd, class_name, 512)
            class_name.read_string
          end

          def close_window(hwnd)
            _close_window(hwnd)
            closed = send_message_timeout(hwnd, Constants::WM_CLOSE,
                                          0, nil, Constants::SMTO_ABORTIFHUNG, 1000, nil)
            # force it to close
            unless closed
              pid = FFI::MemoryPointer.new :int
              window_thread_process_id(hwnd, pid)
              process_hwnd = open_process(Constants::PROCESS_ALL_ACCESS, false, pid.read_int)
              terminate_process(process_hwnd, 0)
              close_handle(process_hwnd)
            end
          end

          def activate_window(hwnd)
            set_foreground_window(hwnd)
            set_active_window(hwnd)
            bring_window_to_top(hwnd)
            foreground_thread = window_thread_process_id(foreground_window, nil)
            other_thread = window_thread_process_id(hwnd, nil)
            attach_thread_input(foreground_thread, other_thread, true) unless other_thread == foreground_thread
            set_foreground_window(hwnd)
            set_active_window(hwnd)
            bring_window_to_top(hwnd)
            attach_thread_input(foreground_thread, other_thread, false) unless other_thread == foreground_thread
          end

          def control_hwnd(window_hwnd, locators)
            find_hwnd(locators, window_hwnd) do |hwnd|
              locators_match?(locators, control_properties(hwnd, locators))
            end
          end

          def control_text(control_hwnd)
            text_for(control_hwnd)
          end

          def control_click(control_hwnd)
            post_message(control_hwnd, Constants::BM_CLICK, 0, nil)
          end

          private

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
              if locator == :index
                true
              elsif value.is_a?(Regexp)
                properties[locator] =~ value
              else
                properties[locator] == value
              end
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