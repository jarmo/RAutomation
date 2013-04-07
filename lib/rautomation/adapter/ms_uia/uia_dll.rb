#todo - move this file up to the same level as the others
#todo - organize the methods better

module RAutomation
  module Adapter
    module MsUia
      module UiaDll
        extend FFI::Library

        HowToFind = enum(:hwnd, 1,
                          :id,
                          :value,
                          :focus,
                          :point)


        class FindData < FFI::Union
          layout :string_data, [:uint8, 256],
                 :int_data, :int,
                 :point_data, [:int, 2]
        end

        class SearchCriteria < FFI::Struct
          def self.from_locator(parent, locator)
            info = SearchCriteria.new
            info.parent_window = parent
            info.index = locator[:index] || 0

            case
              when locator[:hwnd]
                info.how = :hwnd
                info.data = locator[:hwnd]
              when locator[:id]
                info.how = :id
                info.data = locator[:id]
              when locator[:value]
                info.how = :value
                info.data = locator[:value]
              when locator[:point]
                info.how = :point
                info.data = locator[:point]
              when locator[:focus]
                info.how = :focus
            end
            info
          end

          def how
            self[:how]
          end

          def how=(value)
            self[:how] = value
          end

          def index
            self[:index]
          end

          def index=(value)
            self[:index] = value
          end

          def parent_window
            self[:hwnd]
          end

          def parent_window=(parent)
            self[:hwnd] = parent
          end

          def data
            case how
              when :hwnd
                return self[:data][:int_data]
              when :id, :value
                return self[:data][:string_data].to_ptr.read_string
              when :point
                return self[:data][:point_data].to_ptr.read_array_of_int(2)
              else
                return nil
            end
          end

          def data=(value)
            case how
              when :hwnd
                self[:data][:int_data] = value
              when :id, :value
                self[:data][:string_data] = value
              when :point
                self[:data][:point_data].to_ptr.write_array_of_int(value)
            end
          end

          layout :hwnd, :int,
                 :index, :int,
                 :how, HowToFind, :data, FindData
        end

        ffi_lib File.dirname(__FILE__) + '/../../../../ext/UiaDll/Release/UiaDll.dll'
        ffi_convention :stdcall

        # Generic Control methods
        attach_function :ElementExists, [SearchCriteria.by_ref], :bool
        attach_function :process_id, :ProcessId, [SearchCriteria.by_ref], :int
        attach_function :Control_GetValue, [:long, :pointer, :int], :void
        attach_function :set_control_value, :Control_SetValue, [:long, :string], :void
        attach_function :BoundingRectangle, [SearchCriteria.by_ref, :pointer], :int
        attach_function :current_control_type, :ControlType, [SearchCriteria.by_ref], :int
        attach_function :Name, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :ClassName, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :GetClassNames,
                        [SearchCriteria.by_ref, :pointer], :int

        def self.exists?(search_information)
          ElementExists search_information
        end

        def self.bounding_rectangle(search_information)
          boundary = FFI::MemoryPointer.new :long, 4
          BoundingRectangle search_information, boundary
          boundary.read_array_of_long(4)
        end

        def self.get_control_value(hwnd)
          string_from(:Control_GetValue, hwnd)
        end

        def self.name(search_information)
          string_from(:Name, search_information)
        end

        def self.class_name(search_information)
          string_from(:ClassName, search_information)
        end

        def self.children_class_names(search_information)
          strings_from :GetClassNames, search_information
        end

        # Toggle methods
        attach_function :is_set, :IsSet, [SearchCriteria.by_ref], :bool

        # Selection Item methods
        attach_function :is_selected, :IsSelected, [SearchCriteria.by_ref], :bool

        # Select List methods
        attach_function :SelectList_Selection,
                        [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :select_list_count, :SelectList_Count,
                        [SearchCriteria.by_ref], :int
        attach_function :select_list_selected_index, :SelectList_SelectedIndex,
                        [:long], :int
        attach_function :select_list_value_at, :SelectList_ValueAt,
                        [:long, :int, :pointer, :int], :bool
        attach_function :select_list_select_index, :SelectList_SelectIndex,
                        [SearchCriteria.by_ref, :int], :bool
        attach_function :select_list_select_value, :SelectList_SelectValue,
                        [SearchCriteria.by_ref, :pointer], :int

        def self.selection(search_information)
          string_from(:SelectList_Selection, search_information)
        end

        # Menu methods
        attach_function :select_menu_item, :Menu_SelectPath,
                        [:long, :pointer, :int, :varargs], :void
        attach_function :menu_item_exists, :Menu_ItemExists,
                        [:long, :varargs], :bool

        # Table methods
        attach_function :Table_GetHeaders,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :Table_GetValues,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :Table_FindValues,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :table_row_count, :Table_RowCount,
                        [SearchCriteria.by_ref], :int
        attach_function :Table_CoordinateIsValid,
                        [SearchCriteria.by_ref, :int, :int], :bool
        attach_function :Table_ValueAt,
                        [SearchCriteria.by_ref, :int, :int, :pointer, :int], :void
        attach_function :Table_SelectByIndex,
                        [SearchCriteria.by_ref, :int], :void
        attach_function :Table_SelectByValue,
                        [SearchCriteria.by_ref, :string], :void
        attach_function :table_row_is_selected, :Table_IsSelectedByIndex,
                        [SearchCriteria.by_ref, :int], :bool

        def self.table_select(search_information, which_item)
          case which_item
            when Integer
              Table_SelectByIndex search_information, which_item
            when String
              Table_SelectByValue search_information, which_item
          end
        end

        def self.table_value_at(search_information, row, column=0)
          string_from(:Table_ValueAt, search_information, row, column)
        end

        def self.table_coordinate_valid?(search_information, row, column=0)
          Table_CoordinateIsValid search_information, row, column
        end

        def self.table_headers(search_information)
          strings_from :Table_GetHeaders, search_information
        end

        def self.table_values(search_information)
          strings_from :Table_GetValues, search_information
        end

        def self.find_table_values(search_information)
          strings_from :Table_FindValues, search_information
        end

        # String methods
        attach_function :clean_up_strings, :String_CleanUp,
                        [:pointer, :int], :void

        attach_function :element_from_handle, :RA_ElementFromHandle,
                        [:long], :pointer
        attach_function :element_from_point, :RA_ElementFromPoint,
                        [:int, :int], :pointer
        attach_function :find_child_by_id, :RA_FindChildById,
                        [:pointer, :string], :pointer
        attach_function :current_native_window_handle, :RA_CurrentNativeWindowHandle,
                        [:pointer], :long
        attach_function :set_focus, :RA_SetFocus,
                        [:pointer], :bool
        attach_function :move_mouse, :RA_MoveMouse,
                        [:int,:int], :long
        attach_function :click_mouse, :RA_ClickMouse,
                        [], :long
        attach_function :is_offscreen, :RA_CurrentIsOffscreen,
                        [:pointer, :pointer], :int
        attach_function :find_children, :RA_FindChildren,
                        [:pointer, :pointer], :int
        attach_function :get_control_name, :RA_GetControlName,
                        [:long, :pointer, :int], :bool
        attach_function :select, :RA_Select,
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

        def self.string_from(method, *args)
          pointer = FFI::MemoryPointer.new :pointer, 1024
          send method, *(args << pointer << 1024)
          pointer.read_string
        end
      end
    end
  end
end
