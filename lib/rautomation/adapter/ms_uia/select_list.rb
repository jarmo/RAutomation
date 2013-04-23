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
            @text        = text
            @index       = index
          end

          def selected?
            @index == UiaDll::select_list_selected_index(@select_list.search_information)
          end

          def select
            @select_list.assert_enabled
            UiaDll::select_list_select_index @select_list.search_information, @index
          end

          alias_method :set, :select
        end

        def set(value)
          UiaDll::select_list_select_value(search_information, value)
        end

        def options(options = {})
          items = []

          item_count.times do |item_no|
            item = Functions.retrieve_combobox_item_text(search_information, item_no)

            if options[:text]
              items.push(SelectListOption.new(self, item, item_no)) if options[:text] == item
            else
              items.push(SelectListOption.new(self, item, item_no))
            end
          end

          items
        end

        def value
          selected_option = options.find { |option| option.selected? }
          selected_option ? selected_option.text : ""
        end

        def option(options)
          item_count.times do |item_no|
            item = Functions.retrieve_combobox_item_text(search_information, item_no)
            return SelectListOption.new(self, item, item_no) if options[:text] == item
          end

          nil
        end

        def select(index)
          UiaDll::select_list_select_index search_information, index
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
