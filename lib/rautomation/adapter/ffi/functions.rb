module RAutomation
  module Adapter
    module Ffi
      module Functions
        extend FFI::Library

        ffi_lib 'user32'
        ffi_convention :stdcall

        callback :enum_callback, [:long, :pointer], :bool

        attach_function :_enum_windows, :EnumWindows,
                        [:enum_callback, :pointer], :long
        attach_function :_enum_child_windows, :EnumChildWindows,
                        [:long, :enum_callback, :pointer], :long
        attach_function :_window_title, :GetWindowTextA,
                        [:long, :pointer, :int], :int
        attach_function :_window_title_length, :GetWindowTextLengthA,
                        [:long], :int
        attach_function :_window_exists, :IsWindow,
                        [:long], :bool
        attach_function :_window_visible, :IsWindowVisible,
                        [:long], :bool
        attach_function :_send_message, :SendMessageA,
                        [:long, :uint, :uint, :pointer], :long

        class << self
          def window_title(hwnd)
            title_length = self._window_title_length(hwnd) + 1
            title = FFI::MemoryPointer.new :char, title_length
            self._window_title(hwnd, title, title_length)
            title.read_string
          end

          def window_text(hwnd)
            found_text = ""
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |child_hwnd, _|
              text_length = self._send_message(child_hwnd, Constants::WM_GETTEXTLENGTH, 0, nil) + 1
              text = FFI::MemoryPointer.new :char, text_length
              self._send_message(child_hwnd, Constants::WM_GETTEXT, text_length, text)
              found_text << text.read_string
            end
            self._enum_child_windows(hwnd, window_callback, nil)
            found_text
          end
        end
      end
    end
  end
end