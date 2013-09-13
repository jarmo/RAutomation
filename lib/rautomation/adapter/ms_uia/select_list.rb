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
          case value
            when String
              UiaDll::select_list_select_value(search_information, value)
            when Array
              value.each do |item|
                UiaDll::add_to_selection(search_information, item)
              end
          end
        end

        def clear(items)
          items.each {|item| UiaDll::remove_from_selection(search_information, item) }
        end

        def options(options = {})
          items = []

          select_options = UiaDll::select_options(search_information)
          select_options.each_with_index do |item, item_no|
            if options[:text]
              items.push(SelectListOption.new(self, item, item_no)) if options[:text] == item
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

        def option(options)
          UiaDll::select_options(search_information).each_with_index do |item, item_no|
            return SelectListOption.new(self, item, item_no) if options[:text] == item
          end

          nil
        end

        def select(which_item)
          case which_item
            when Fixnum
              UiaDll::select_list_select_index search_information, which_item
            when Array
              which_item.each do |item|
                UiaDll::add_to_selection(search_information, item)
              end
          end
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
