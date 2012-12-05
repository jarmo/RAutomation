module RAutomation
  module Adapter
    module MsUia
      class Table < Control
        include WaitHelper
        include Locators

        class Item
          attr_reader :row

          def initialize(hwnd, row)
            @hwnd = hwnd
            @row = row
          end

          def value
            string = FFI::MemoryPointer.new :char, 1024
            UiaDll::table_value_at @hwnd, @row, string, 1024
            string.read_string
          end

          def cells
            cells = []
            UiaDll::get_data_item_row_count(@hwnd).times do |column|
              cells << Cell.new(@hwnd, @row, column)
            end
            cells
          end

          class Cell
            attr_reader :location

            def initialize(hwnd, row, column)
              @hwnd = hwnd
              @location = [row, column]
            end

            def value
              string = FFI::MemoryPointer.new :char, 1024
              UiaDll::cell_value_at @hwnd, @location[0], @location[1], string, 1024
              string.read_string
            end
          end
        end

        def strings
          rows = []
          header_columns = []

          raise "Not a list control" unless of_type_table?


          children_count = count_children(uia_element)

          children = FFI::MemoryPointer.new :pointer, children_count
          UiaDll::find_children(uia_element, children)


          children.read_array_of_pointer(children_count).each do |child|
            grandchildren_count = count_children(child)

            if grandchildren_count > 0

              grandchildren = FFI::MemoryPointer.new :pointer, grandchildren_count
              UiaDll::find_children(child, grandchildren)

              grandchildren.read_array_of_pointer(grandchildren_count).each do |grandchild|
                grandchild_name = FFI::MemoryPointer.new :char, UiaDll::get_name(grandchild, nil) + 1
                UiaDll::get_name(grandchild, grandchild_name)
                header_columns.push grandchild_name.read_string
              end
            else
              grandchild_name = FFI::MemoryPointer.new :char, UiaDll::get_name(child, nil) + 1
              UiaDll::get_name(child, grandchild_name)
              header_columns = grandchild_name.read_string
            end

            rows.push header_columns
            header_columns = []
          end

          rows
        end

#        def select(row)
#          Functions.select_table_row(Window.oleacc_module_handle, Functions.control_hwnd(@window.hwnd, @locators), row)
#        end

        def select(index)
          UiaDll::select_data_item hwnd, index - 1
        end

        #todo - replace with UIA version
        def selected?(row)
          state = Functions.get_table_row_state(Window.oleacc_module_handle, hwnd, row)
          state & Constants::STATE_SYSTEM_SELECTED != 0
        end

        def row_count
          UiaDll::get_data_item_count hwnd
        end

        def items
          table_items = []
          row_count.times do |row|
            table_items << Item.new(hwnd, row)
          end
          table_items
        end

        def exist?
          super && of_type_table?
        end

        def of_type_table?
          matches_type?(Constants::UIA_LIST_CONTROL_TYPE) || matches_type?(Constants::UIA_DATA_GRID_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

        private

        def count_children(element)
          UiaDll::find_children(element, nil)
        end

      end
    end
  end
end
