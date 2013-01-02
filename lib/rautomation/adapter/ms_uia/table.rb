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
          @column = @locators[:index] || 0
        end

        def exists?
          UiaDll::table_coordinate_valid? hwnd, row, column
        end

        def value
          UiaDll::table_value_at hwnd, row, column
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
          UiaDll::table_value_at @hwnd, @locators[:index]
        end

        def exists?
          UiaDll::table_coordinate_valid?(@hwnd, @locators[:index])
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
          headers = UiaDll.table_headers(hwnd)
          values = UiaDll.table_values(hwnd)
          return values if headers.empty?

          all_strings = [] << headers
          values.each_slice(headers.count) {|r| all_strings << r }
          all_strings
        end

        def select(which_item)
          UiaDll::table_select hwnd, which_item
        end

        def selected?(which_item)
          UiaDll::table_row_is_selected hwnd, which_item
        end

        def row_count
          UiaDll::table_row_count hwnd
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
