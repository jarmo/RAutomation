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

        def self.exists?(parent, locator)
          ElementExists SearchCriteria.from_locator(parent, locator)
        end

        def self.bounding_rectangle(parent, locator)
          boundary = FFI::MemoryPointer.new :long, 4
          BoundingRectangle SearchCriteria.from_locator(parent, locator), boundary
          boundary.read_array_of_long(4)
        end

        def self.get_control_value(hwnd)
          string = FFI::MemoryPointer.new :char, 1024
          Control_GetValue hwnd, string, 1024
          string.read_string
        end

        def self.name(search_information)
          name = FFI::MemoryPointer.new :char, 1024
          Name search_information, name, 1024
          name.read_string
        end

        def self.class_name(search_information)
          class_name = FFI::MemoryPointer.new :char, 1024
          ClassName search_information, class_name, 1024
          class_name.read_string
        end

        def self.children_class_names(search_information)
          strings_from :GetClassNames, search_information
        end

        # Toggle methods
        attach_function :is_set, :IsSet, [SearchCriteria.by_ref], :bool

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
        attach_function :Table_FindValues,
                        [SearchCriteria.by_ref, :pointer], :int
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

        def self.find_table_values(parent, locator)
          strings_from :Table_FindValues, SearchCriteria.from_locator(parent, locator)
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
        attach_function :get_is_selected, :RA_GetIsSelected,
                        [:pointer], :bool
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
      end
    end
  end
end
