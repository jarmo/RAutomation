module RAutomation
  module Adapter
    module MsUia

      class SelectList < Control
        include WaitHelper
        include Locators

        class SelectListOption
          attr_accessor :text, :index

          def initialize(select_list, text, index)
            @select_list = select_list
            @text = text
            @index = index
          end

          def selected?
            @index == UiaDll::select_list_selected_index(@select_list.search_information)
          end

          def select
            @select_list.assert_enabled
            UiaDll::select_list_select_index @select_list.search_information, @index
          end

          def clear
            UiaDll::remove_from_selection @select_list.search_information, @index
          end

          def self.locators_match?(locators, item)
            locators.all? do |locator, value|
              return item.text =~ value if value.is_a? Regexp
              return item.send(locator) == value
            end
          end

          alias_method :set, :select
        end

        def option(locator)
          options(locator).first
        end

        def options(locator = {})
          all_options.select { |item| SelectListOption.locators_match? locator, item }
        end

        def select(locator)
          options(locator).each(&:select)
        end

        def value
          UiaDll::selection(search_information)
        end

        def values
          UiaDll::selections(search_information)
        end

        def exist?
          super && matches_type?(Constants::UIA_COMBOBOX_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

        private
        def item_count
          UiaDll::select_list_count(search_information)
        end

        def all_options
          UiaDll::select_options(search_information).each_with_index.map do |item, index|
            SelectListOption.new(self, item, index)
          end
        end

      end
    end
  end
end
