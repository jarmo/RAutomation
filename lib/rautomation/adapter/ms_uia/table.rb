module RAutomation
  module Adapter
    module MsUia
      class Cell
        include Locators
        attr_reader :row, :column, :hwnd

        def initialize(window, locators)
          @hwnd = window.hwnd
          @locators = extract(locators)
          @row = window.row
          @column = @locators[:index]
        end

        def exists?
          UiaDll::data_item_exists hwnd, row, column
        end

        def value
          UiaDll::cell_value_at hwnd, row, column
        end

        alias_method :text, :value
        alias_method :index, :column
      end

      class Row
        include Locators
        extend ElementCollections
        attr_reader :hwnd

        has_many :cells

        def cells(locators={})
          Cells.new(self, locators).select do |cell|
            Row.locators_match? locators, cell
          end
        end

        def cell(locators={})
          cells(locators).first
        end

        def initialize(window, locators)
          @hwnd = window.hwnd
          @locators = extract(locators)
        end

        def index
          @locators[:index] || 0
        end

        def value
          UiaDll::cell_value_at @hwnd, @locators[:index]
        end

        def exists?
          UiaDll::data_item_exists(@hwnd, @locators[:index])
        end

        def self.locators_match?(locators, item)
          locators.all? do |locator, value|
            return item.value =~ value if value.is_a? Regexp
            return item.send(locator) == value
          end
        end

        alias_method :text, :value
        alias_method :row, :index
      end

      class Table < Control
        include WaitHelper
        include Locators
        extend ElementCollections

        has_many :rows

        def row(locators={})
          rows(locators).first
        end

        def rows(locators={})
          Rows.new(self, locators).select do |row|
            Row.locators_match? locators, row
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
