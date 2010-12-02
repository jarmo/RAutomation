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
        attach_function :window_visible, :IsWindowVisible,
                        [:long], :bool
        attach_function :show_window, :ShowWindow,
                        [:long, :int], :bool
        attach_function :send_message, :SendMessageA,
                        [:long, :uint, :uint, :pointer], :long
        attach_function :send_message_timeout, :SendMessageTimeoutA,
                        [:long, :uint, :uint, :pointer, :uint, :uint, :pointer], :bool
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

        # kernel32
        attach_function :open_process, :OpenProcess,
                        [:int, :bool, :int], :long
        attach_function :terminate_process, :TerminateProcess,
                        [:long, :uint], :bool
        attach_function :close_handle, :CloseHandle,
                        [:long], :bool

        class << self
          def window_title(hwnd)
            title_length = self.window_title_length(hwnd) + 1
            title = FFI::MemoryPointer.new :char, title_length
            self._window_title(hwnd, title, title_length)
            title.read_string
          end

          def window_text(hwnd)
            found_text = ""
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |child_hwnd, _|
              text_length = self.send_message(child_hwnd, Constants::WM_GETTEXTLENGTH, 0, nil) + 1
              text = FFI::MemoryPointer.new :char, text_length
              self.send_message(child_hwnd, Constants::WM_GETTEXT, text_length, text)
              found_text << text.read_string
            end
            self.enum_child_windows(hwnd, window_callback, nil)
            found_text
          end

          def window_hwnd(locators)
            found_hwnd = nil
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |hwnd, _|
              if !self.window_visible(hwnd) || self.window_text(hwnd).empty?
                true
              else
                properties = window_properties(hwnd, locators)
                locators_match = locators.all? do |locator, value|
                  if value.is_a?(Regexp)
                    properties[locator] =~ value
                  else
                    properties[locator] == value
                  end
                end

                if locators_match
                  found_hwnd = hwnd
                  false
                else
                  true
                end
              end
            end

            self.enum_windows(window_callback, nil)
            found_hwnd
          end

          def close_window(hwnd)
            self._close_window(hwnd)
            closed = self.send_message_timeout(hwnd, Constants::WM_CLOSE,
                                               0, nil, Constants::SMTO_ABORTIFHUNG, 1000, nil)
            # force it to close
            unless closed
              pid = FFI::MemoryPointer.new :int
              self.window_thread_process_id(hwnd, pid)
              process_hwnd = self.open_process(Constants::PROCESS_ALL_ACCESS, false, pid.read_int)
              self.terminate_process(process_hwnd, 0)
              self.close_handle(process_hwnd)
            end
          end

          def activate_window(hwnd)
            self.set_foreground_window(hwnd)
            self.set_active_window(hwnd)
            self.bring_window_to_top(hwnd)
            foreground_thread = self.window_thread_process_id(self.foreground_window, nil)
            other_thread = self.window_thread_process_id(hwnd, nil)
            self.attach_thread_input(foreground_thread, other_thread, true) unless other_thread == foreground_thread
            self.set_foreground_window(hwnd)
            self.set_active_window(hwnd)
            self.bring_window_to_top(hwnd)
            self.attach_thread_input(foreground_thread, other_thread, false) unless other_thread == foreground_thread
          end

          private

          def window_properties(hwnd, locators)
            locators.inject({}) do |properties, locator|
              properties[locator[0]] = self.send("window_#{locator[0]}", hwnd)
              properties
            end
          end

        end
      end
    end
  end
end