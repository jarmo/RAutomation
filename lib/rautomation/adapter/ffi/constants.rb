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

        # keybd_event constants
        # http://msdn.microsoft.com/en-us/library/ms646304(VS.85).aspx
        #
        # keycodes themselves are at:
        # http://msdn.microsoft.com/en-us/library/dd375731(v=VS.85).aspx
        KEYEVENTF_EXTENDEDKEY = 0x1
        KEYEVENTF_KEYUP = 0x2
      end
    end
  end
end