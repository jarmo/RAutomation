module RAutomation
  module Adapter
    module Win32
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
        BM_GETSTATE = 0xF2
        BST_CHECKED = 0x1

        # keybd_event constants
        KEYEVENTF_EXTENDEDKEY = 0x1
        KEYEVENTF_KEYUP = 0x2

        # GetWindow constants
        GW_ENABLEDPOPUP = 6

        # HRESULT
        S_OK = 0

        # IAccessible Button States
        STATE_SYSTEM_UNAVAILABLE = 0x00000001
        STATE_SYSTEM_SELECTED = 0x00000002
        STATE_SYSTEM_FOCUSED = 0x00000004
        STATE_SYSTEM_CHECKED = 0x00000010

        # Combobox
        CB_GETCOUNT = 0x0146
        CB_GETTOPINDEX  = 0x015b
        CB_GETLBTEXTLEN = 0x0149
        CB_GETLBTEXT = 0x0148
        CB_GETCURSEL = 0x0147
        CB_GETDROPPEDCONTROLRECT = 0x0152
        CB_GETITEMHEIGHT = 0x0154
        CB_ERR = -1
        CB_SETCURSEL = 0x14E
        CB_SELECTSTRING = 0x14D
        CB_SETEDITSEL = 0x142

        # listview
        LVM_FIRST = 0x1000
        LVM_GETITEMCOUNT = LVM_FIRST + 4

        # listbox
        LB_GETCOUNT = 0x18b
        LB_GETTEXT = 0x189
        LB_GETTEXTLEN = 0x18a
        LB_SETCURSEL = 0x186
        LB_GETSEL = 0x187

        # SendInput
        INPUT_MOUSE = 0
        MOUSEEVENTF_LEFTDOWN = 0x2
        MOUSEEVENTF_LEFTUP = 0x4

      end
    end
  end
end
