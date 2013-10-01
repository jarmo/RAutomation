module RAutomation
  module Adapter
    module MsUia
      class Cell
        include Locators
        attr_reader :row, :column, :search_information

        def initialize(window, locators)
          @search_information = window.search_information
          @locators = extract(locators)
          @row = window.row
          @column = @locators[:index] || 0
        end

        def exists?
          UiaDll::table_coordinate_valid? search_information, row, column
        end

        def value
          UiaDll::table_value_at search_information, row, column
        end

        alias_method :text, :value
        alias_method :index, :column
      end

      class Row
        include Locators
        extend ElementCollections
        attr_reader :search_information

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
          @search_information = window.search_information
          @locators = extract(locators)
        end

        def index
          @locators[:index] || 0
        end

        def select
          UiaDll::table_select search_information, row
        end

        def selected?
          UiaDll::table_row_is_selected search_information, row
        end

        def clear
          UiaDll::table_remove_from_selection search_information, row
        end

        def value
          UiaDll::table_value_at search_information, @locators[:index]
        end

        def exists?
          UiaDll::table_coordinate_valid?(search_information, @locators[:index])
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
          headers = UiaDll.table_headers(search_information)
          values = UiaDll.table_values(search_information)
          return values if headers.empty?

          all_strings = [] << headers
          values.each_slice(headers.count) {|r| all_strings << r }
          all_strings
        end

        def row_count
          UiaDll::table_row_count search_information
        end

        def exist?
          super && of_type_table?
        end

        def of_type_table?
          matches_type?(Constants::UIA_LIST_CONTROL_TYPE) || matches_type?(Constants::UIA_DATA_GRID_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?
      end
    end
  end
end
