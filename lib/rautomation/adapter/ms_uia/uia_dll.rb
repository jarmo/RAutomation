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
            info.children_only = locator[:children_only]

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

          def children_only?
            self[:children_only]
          end

          def children_only=(yes_or_no)
            self[:children_only] = yes_or_no
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
                 :children_only, :bool,
                 :how, HowToFind, :data, FindData
        end

        def self.uia_dll_directory
          File.dirname(__FILE__) + '/../../../../ext/UiaDll/Release'
        end


        ffi_lib File.join(uia_dll_directory, 'UiaDll.dll')
        ffi_convention :stdcall

        attach_function :init, :initialize, [:string], :void
        init(uia_dll_directory)

        # Generic Control methods
        attach_function :cached_hwnd, :NativeWindowHandle, [SearchCriteria.by_ref], :long
        attach_function :ElementExists, [SearchCriteria.by_ref], :bool
        attach_function :process_id, :ProcessId, [SearchCriteria.by_ref], :int
        attach_function :Control_GetValue, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :set_control_value, :Control_SetValue, [SearchCriteria.by_ref, :string], :void
        attach_function :Text_GetValue, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :set_text, :Text_SetValue, [SearchCriteria.by_ref, :string], :void
        attach_function :BoundingRectangle, [SearchCriteria.by_ref, :pointer], :int
        attach_function :current_control_type, :ControlType, [SearchCriteria.by_ref], :int
        attach_function :Name, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :ClassName, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :is_enabled, :IsEnabled, [SearchCriteria.by_ref], :bool
        attach_function :is_focused, :IsFocused, [SearchCriteria.by_ref], :bool
        attach_function :set_focus, :SetControlFocus, [SearchCriteria.by_ref], :bool
        attach_function :GetClassNames, [SearchCriteria.by_ref, :pointer], :int
        attach_function :HelpText, [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :SendKeys, [SearchCriteria.by_ref, :string, :pointer, :int], :void

        def self.exists?(search_information)
          ElementExists search_information
        end

        def self.bounding_rectangle(search_information)
          boundary = FFI::MemoryPointer.new :long, 4
          BoundingRectangle search_information, boundary
          boundary.read_array_of_long(4)
        end

        def self.get_control_value(search_information)
          string_from(:Control_GetValue, search_information)
        end

        def self.get_text(search_information)
          string_from(:Text_GetValue, search_information)
        end

        def self.help_text(search_information)
          string_from(:HelpText, search_information)
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

        def self.send_keys(search_information, keys_to_send)
          can_throw(:SendKeys, search_information, keys_to_send)
        end

        # Toggle methods
        attach_function :is_set, :IsSet, [SearchCriteria.by_ref], :bool

        # Selection Item methods
        attach_function :is_selected, :IsSelected, [SearchCriteria.by_ref], :bool

        # Select List methods
        attach_function :SelectList_Selection,
                        [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :SelectList_Selections,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :SelectList_Options,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :select_list_count, :SelectList_Count,
                        [SearchCriteria.by_ref], :int
        attach_function :select_list_selected_index, :SelectList_SelectedIndex,
                        [SearchCriteria.by_ref], :int
        attach_function :select_list_value_at, :SelectList_ValueAt,
                        [SearchCriteria.by_ref, :int, :pointer, :int], :bool
        attach_function :select_list_select_index, :SelectList_SelectIndex,
                        [SearchCriteria.by_ref, :int], :bool
        attach_function :select_list_select_value, :SelectList_SelectValue,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :SelectList_RemoveIndex,
                        [SearchCriteria.by_ref, :int, :pointer, :int], :void
        attach_function :SelectList_RemoveValue,
                        [SearchCriteria.by_ref, :string, :pointer, :int], :void

        def self.select_options(search_information)
          strings_from(:SelectList_Options, search_information)
        end

        def self.selection(search_information)
          string_from(:SelectList_Selection, search_information)
        end

        def self.selections(search_information)
          strings_from(:SelectList_Selections, search_information)
        end

        def self.remove_from_selection(search_information, which_item)
          case which_item
            when Fixnum
              can_throw(:SelectList_RemoveIndex, search_information, which_item)
            when String
              can_throw(:SelectList_RemoveValue, search_information, which_item)
          end
        end

        # Spinner methods
        attach_function :Spinner_GetValue,
                        [SearchCriteria.by_ref, :pointer, :int], :double
        attach_function :Spinner_SetValue,
                        [SearchCriteria.by_ref, :double, :pointer, :int], :void
        attach_function :Spinner_Minimum,
                        [SearchCriteria.by_ref, :pointer, :int], :double
        attach_function :Spinner_Maximum,
                        [SearchCriteria.by_ref, :pointer, :int], :double
        attach_function :Spinner_Increment,
                        [SearchCriteria.by_ref, :pointer, :int], :double
        attach_function :Spinner_Decrement,
                        [SearchCriteria.by_ref, :pointer, :int], :double

        def self.spinner_value(search_information)
          can_throw(:Spinner_GetValue, search_information)
        end

        def self.set_spinner_value(search_information, value)
          can_throw(:Spinner_SetValue, search_information, value)
        end

        def self.spinner_min(search_information)
          can_throw(:Spinner_Minimum, search_information)
        end

        def self.spinner_max(search_information)
          can_throw(:Spinner_Maximum, search_information)
        end

        def self.increment_spinner(search_information)
          can_throw(:Spinner_Increment, search_information)
        end

        def self.decrement_spinner(search_information)
          can_throw(:Spinner_Decrement, search_information)
        end

        # Tab Control methods
        attach_function :TabControl_Items,
                        [SearchCriteria.by_ref, :pointer], :int
        attach_function :TabControl_Selection,
                        [SearchCriteria.by_ref, :pointer, :int], :void
        attach_function :TabControl_SelectByIndex,
                        [SearchCriteria.by_ref, :int, :pointer, :int], :void
        attach_function :TabControl_SelectByValue,
                        [SearchCriteria.by_ref, :string, :pointer, :int], :void
        attach_function :tab_control_selected_index, :TabControl_SelectedIndex, [SearchCriteria.by_ref], :int

        def self.tab_items(search_information)
          strings_from(:TabControl_Items, search_information)
        end

        def self.tab_selection(search_information)
          string_from(:TabControl_Selection, search_information)
        end

        def self.select_tab(search_information, which)
          case which
            when Fixnum
              can_throw(:TabControl_SelectByIndex, search_information, which)
            when String
              can_throw(:TabControl_SelectByValue, search_information, which)
          end
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
        attach_function :table_row_count, :Table_RowCount,
                        [SearchCriteria.by_ref], :int
        attach_function :Table_CoordinateIsValid,
                        [SearchCriteria.by_ref, :int, :int], :bool
        attach_function :Table_ValueAt,
                        [SearchCriteria.by_ref, :int, :int, :pointer, :int], :void
        attach_function :Table_SelectByIndex,
                        [SearchCriteria.by_ref, :int, :pointer, :int], :void
        attach_function :Table_SelectByValue,
                        [SearchCriteria.by_ref, :string, :pointer, :int], :void
        attach_function :table_row_is_selected, :Table_IsSelectedByIndex,
                        [SearchCriteria.by_ref, :int], :bool
        attach_function :Table_RemoveRowByIndex,
                        [SearchCriteria.by_ref, :int, :pointer, :int], :void
        attach_function :Table_RemoveRowByValue,
                        [SearchCriteria.by_ref, :string, :pointer, :int], :void

        def self.table_select(search_information, which_item)
          case which_item
            when Integer
              can_throw(:Table_SelectByIndex, search_information, which_item)
            when String
              can_throw(:Table_SelectByValue, search_information, which_item)
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

        def self.table_remove_from_selection(search_information, which_row)
          case which_row
            when Fixnum
              can_throw(:Table_RemoveRowByIndex, search_information, which_row)
            when String
              can_throw(:Table_RemoveRowByValue, search_information, which_row)
          end
        end

        # String methods
        attach_function :clean_up_strings, :String_CleanUp,
                        [:pointer, :int], :void

        attach_function :handle_from_point, :HandleFromPoint,
                        [:int, :int], :long
        attach_function :move_mouse, :MoveMouse,
                        [:int,:int], :long
        attach_function :click_mouse, :ClickMouse,
                        [], :long
        attach_function :is_offscreen, :IsOffscreen,
                        [SearchCriteria.by_ref], :bool
        attach_function :expand_by_value, :ExpandItemByValue,
                        [SearchCriteria.by_ref, :string], :void
        attach_function :expand_by_index, :ExpandItemByIndex,
                        [SearchCriteria.by_ref, :int], :void
        attach_function :collapse_by_value, :CollapseItemByValue,
                        [SearchCriteria.by_ref, :string], :void
        attach_function :collapse_by_index, :CollapseItemByIndex,
                        [SearchCriteria.by_ref, :int], :void
        attach_function :Click,
                        [SearchCriteria.by_ref, :pointer, :int], :bool

        def self.control_click(search_information)
          can_throw(:Click, search_information)
        end

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

        def self.can_throw(method, *args)
          string_buffer = FFI::MemoryPointer.new :char, 1024
          result = send method, *(args << string_buffer << 1024)
          error_info = string_buffer.read_string
          raise error_info unless error_info.empty?
          result
        end
      end
    end
  end
end
