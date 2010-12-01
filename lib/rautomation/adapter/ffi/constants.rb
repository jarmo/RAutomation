module RAutomation
  module Adapter
    module Ffi
      module Constants
        WM_GETTEXT = 0xD
        WM_GETTEXTLENGTH = 0xE
        WM_CLOSE = 0x10

        SW_MAXIMIZE = 3
        SW_MINIMIZE = 6
        SW_RESTORE = 9

        SMTO_ABORTIFHUNG = 0x2

        STANDARD_RIGHTS_REQUIRED = 0xF0000 
        SYNCHRONIZE = 0x100000
        PROCESS_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0xFFF
      end
    end
  end
end