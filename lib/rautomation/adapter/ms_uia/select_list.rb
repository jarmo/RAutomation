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

          alias_method :set, :select
        end

        def option(locator)
          options(locator).first
        end

        def options(locator = {})
          items = []

          select_options = UiaDll::select_options(search_information)
          select_options.each_with_index do |item, item_no|
            case
              when locator[:text]
                case locator[:text]
                  when Regexp
                    items.push(SelectListOption.new(self, item, item_no)) if locator[:text] =~ item
                  else
                    items.push(SelectListOption.new(self, item, item_no)) if locator[:text] == item
                end
              when locator[:index]
                items.push(SelectListOption.new(self, item, item_no)) if item_no == locator[:index]
              else
                items.push(SelectListOption.new(self, item, item_no))
            end
          end

          items
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

      end
    end
  end
end
