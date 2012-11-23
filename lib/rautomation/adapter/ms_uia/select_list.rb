module RAutomation
  module Adapter
    module MsUia

      class SelectList < Control
        include WaitHelper
        include Locators

        class SelectListOption
          attr_accessor :text, :index, :control_hwnd

          def initialize(select_list, text, index)
            @select_list = select_list
            @text        = text
            @index       = index
          end

          def selected?
            @index == UiaDll::get_combobox_selected_index(@select_list.control_hwnd)
          end

          def select
            @select_list.assert_enabled
            UiaDll::select_combo_by_index @select_list.control_hwnd, @index
          end

          alias_method :set, :select
        end

        def initialize(window, locators)
          super
          @hwnd = Functions.control_hwnd(@window.hwnd, @locators)
        end

        def set(value)
          list      = UiaDll::element_from_handle(@hwnd)
          UiaDll::set_value(list, value)
        end

        def options(options = {})
          items = []

          item_count.times do |item_no|
            item = Functions.retrieve_combobox_item_text(@hwnd, item_no)

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
            item = Functions.retrieve_combobox_item_text(@hwnd, item_no)
            return SelectListOption.new(self, item, item_no) if options[:text] == item
          end

          nil
        end

        def control_hwnd
          @hwnd
        end

        def select(index)
          UiaDll::select_combo_by_index @hwnd, index
        end

        def list_item_height
          Functions.send_message(@hwnd, Constants::CB_GETITEMHEIGHT, 0 ,nil)
        end

        def dropbox_boundary
          boundary = FFI::MemoryPointer.new :long, 4

          Functions.send_message(@hwnd, Constants::CB_GETDROPPEDCONTROLRECT, 0 ,boundary)

          boundary.read_array_of_long(4)
        end

        def get_top_index
          Functions.send_message(@hwnd, Constants::CB_GETTOPINDEX, 0 ,nil)
        end

        def scroll_to_item(row)
          Functions.send_message(@hwnd, Constants::CB_SETTOPINDEX , row ,nil)
        end

        def exist?
          super && matches_type?(Constants::UIA_COMBOBOX_CONTROL_TYPE)
        end

        alias_method :exists?, :exist?

        private

        def item_count
          UiaDll::get_combobox_count(@hwnd)
        end

      end
    end
  end
end
