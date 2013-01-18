#todo - move this file up to the same level as the others
#todo - organize the methods better

module RAutomation
  module Adapter
    module MsUia
      module UiaDll
        extend FFI::Library

        ffi_lib File.dirname(__FILE__) + '/../../../../ext/UiaDll/Release/UiaDll.dll'
        ffi_convention :stdcall

        # Select List methods
        attach_function :select_list_count, :SelectList_Count,
                        [:long], :int
        attach_function :select_list_selected_index, :SelectList_SelectedIndex,
                        [:long], :int
        attach_function :select_list_value_at, :SelectList_ValueAt,
                        [:long, :int, :pointer, :int], :bool
        attach_function :select_list_select_index, :SelectList_SelectIndex,
                        [:long, :int], :bool
        attach_function :select_list_select_value, :SelectList_SelectValue,
                        [:pointer, :pointer], :int

        # Menu methods
        attach_function :select_menu_item, :Menu_SelectPath,
                        [:long, :pointer, :int, :varargs], :void
        attach_function :menu_item_exists, :Menu_ItemExists,
                        [:long, :varargs], :bool

        # Table methods
        attach_function :Table_GetHeaders,
                        [:long, :pointer], :int
        attach_function :Table_GetValues,
                        [:long, :pointer], :int
        attach_function :table_row_count, :Table_RowCount,
                        [:long], :int
        attach_function :Table_CoordinateIsValid,
                        [:long, :int, :int], :bool
        attach_function :Table_ValueAt,
                        [:long, :int, :int, :pointer, :int], :void
        attach_function :Table_SelectByIndex,
                        [:long, :int], :void
        attach_function :Table_SelectByValue,
                        [:long, :string], :void
        attach_function :table_row_is_selected, :Table_IsSelectedByIndex,
                        [:long, :int], :bool

        def self.table_select(hwnd, which_item)
          case which_item
            when Integer
              Table_SelectByIndex hwnd, which_item
            when String
              Table_SelectByValue hwnd, which_item
          end
        end

        def self.table_value_at(hwnd, row, column=0)
          string = FFI::MemoryPointer.new :char, 1024
          Table_ValueAt hwnd, row, column, string, 1024
          string.read_string
        end

        def self.table_coordinate_valid?(hwnd, row, column=0)
          Table_CoordinateIsValid hwnd, row, column
        end

        def self.table_headers(hwnd)
          strings_from :Table_GetHeaders, hwnd
        end

        def self.table_values(hwnd)
          strings_from :Table_GetValues, hwnd
        end

        # String methods
        attach_function :clean_up_strings, :String_CleanUp,
                        [:pointer, :int], :void

        attach_function :find_window, :RA_FindWindow,
                        [:string], :pointer
        attach_function :element_from_handle, :RA_ElementFromHandle,
                        [:long], :pointer
        attach_function :element_from_point, :RA_ElementFromPoint,
                        [:int, :int], :pointer
        attach_function :get_focused_element, :RA_GetFocusedElement,
                        [], :pointer
        attach_function :find_child_by_id, :RA_FindChildById,
                        [:pointer, :string], :pointer
        attach_function :find_child_by_name, :RA_FindChildByName,
                        [:pointer, :string], :pointer
        attach_function :current_native_window_handle, :RA_CurrentNativeWindowHandle,
                        [:pointer], :long
        attach_function :set_focus, :RA_SetFocus,
                        [:pointer], :bool
        attach_function :current_control_type, :RA_GetCurrentControlType,
                        [:pointer], :int
        attach_function :desktop_handle, :RA_GetDesktopHandle,
                        [], :long
        attach_function :move_mouse, :RA_MoveMouse,
                        [:int,:int], :long
        attach_function :click_mouse, :RA_ClickMouse,
                        [], :long
        attach_function :bounding_rectangle, :RA_CurrentBoundingRectangle,
                        [:pointer, :pointer], :int
        attach_function :is_offscreen, :RA_CurrentIsOffscreen,
                        [:pointer, :pointer], :int
        attach_function :find_children, :RA_FindChildren,
                        [:pointer, :pointer], :int
        attach_function :get_name, :RA_GetName,
                        [:pointer, :pointer], :int
        attach_function :get_control_name, :RA_GetControlName,
                        [:long, :pointer, :int], :bool
        attach_function :get_class_name, :RA_GetClassName,
                        [:pointer, :pointer], :int
        attach_function :get_is_selected, :RA_GetIsSelected,
                        [:pointer], :bool
        attach_function :get_is_set, :RA_GetIsSet,
                        [:pointer], :bool
        attach_function :select, :RA_Select,
                        [:pointer], :int
        attach_function :find_window_by_pid, :RA_FindWindowByPID,
                        [:int], :pointer
        attach_function :current_process_id, :RA_GetCurrentProcessId,
                        [:pointer], :int
        attach_function :expand_by_value, :RA_ExpandItemByValue,
                        [:long, :string], :void
        attach_function :expand_by_index, :RA_ExpandItemByIndex,
                        [:long, :int], :void
        attach_function :collapse_by_value, :RA_CollapseItemByValue,
                        [:long, :string], :void
        attach_function :collapse_by_index, :RA_CollapseItemByIndex,
                        [:long, :int], :void
        attach_function :control_click, :RA_Click,
                        [:long, :pointer, :int], :void
        attach_function :control_mouse_click, :RA_PointAndClick,
                        [:long, :pointer, :int], :void

        private
        def self.strings_from(method, hwnd)
          string_count = send method, hwnd, nil
          pointer = FFI::MemoryPointer.new :pointer, string_count
          send method, hwnd, pointer
          strings = pointer.get_array_of_string 0, string_count
          clean_up_strings pointer, string_count
          strings
        end
      end
    end
  end
end
