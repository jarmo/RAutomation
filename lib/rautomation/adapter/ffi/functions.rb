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
        attach_function :_window_title, :GetWindowTextA,
                        [:long, :pointer, :int], :int
        attach_function :_window_title_length, :GetWindowTextLengthA,
                        [:long], :int
        attach_function :_window_visible, :IsWindowVisible,
                        [:long], :bool

        class << self
          def window_title(hwnd)
            title_length = Functions._window_title_length(hwnd) + 1
            title = FFI::MemoryPointer.new :char, title_length
            Functions._window_title(hwnd, title, title_length)
            title.read_string
          end

          def window_text(hwnd)
            "notempty"
          end
        end
      end
    end
  end
end