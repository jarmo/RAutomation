module RAutomation
  module Adapter
    module MsUiAutomation
      # @private
      module UiaDll
        extend FFI::Library

        ffi_lib File.dirname(__FILE__) + '/../../../../ext/UiaDll/Release/UiaDll.dll'
        ffi_convention :stdcall

        attach_function :find_window, :RA_FindWindow,
                        [:string], :pointer
        attach_function :is_offscreen, :RA_IsOffscreen,
                        [:pointer], :bool

      end
    end
  end
end
