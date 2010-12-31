module RAutomation
  module Adapter
    module WinFfi
      # @private
      module Constants
        WM_GETTEXT = 0xD
        WM_SETTEXT = 0xC
        WM_GETTEXTLENGTH = 0xE
        WM_CLOSE = 0x10

        SW_MAXIMIZE = 3
        SW_MINIMIZE = 6
        SW_RESTORE = 9

        SMTO_ABORTIFHUNG = 0x2

        STANDARD_RIGHTS_REQUIRED = 0xF0000 
        SYNCHRONIZE = 0x100000
        PROCESS_ALL_ACCESS = STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | 0xFFF

        BM_CLICK = 0xF5
        BM_GETSTATE = 0x00F2
        BST_CHECKED = 0x0001

        # keybd_event constants
        KEYEVENTF_EXTENDEDKEY = 0x1
        KEYEVENTF_KEYUP = 0x2

        # GetWindow constants
        GW_ENABLEDPOPUP = 6
      end
    end
  end
end