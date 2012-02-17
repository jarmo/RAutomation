module RAutomation
  module Adapter
    module Win32
      class SelectList < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /combobox/i}

        class SelectListOption
          attr_accessor :text, :index

          def initialize(select_list, text, index)
            @select_list = select_list
            @text        = text
            @index       = index
          end

          def selected?
            selected_idx = Functions.send_message(@select_list.hwnd, Constants::CB_GETCURSEL, 0, nil)
            return false if selected_idx == Constants::CB_ERR
            @text == Functions.retrieve_combobox_item_text(@select_list.hwnd, selected_idx)
          end

          def select
            @select_list.send :assert_enabled
            Functions.send_message(@select_list.hwnd, Constants::CB_SETCURSEL, @index, nil) != Constants::CB_ERR
          end

          alias_method :set, :select
        end

        def options(options = {})
          items = []

          item_count.times do |item_no|
            item = Functions.retrieve_combobox_item_text(hwnd, item_no)

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
            item = Functions.retrieve_combobox_item_text(hwnd, item_no)
            return SelectListOption.new(self, item, item_no) if options[:text] == item
          end

          nil
        end

        def select(index)
          Functions.send_message(hwnd, Constants::CB_SETCURSEL, index, nil) != Constants::CB_ERR
        end

        def set(text)
          option(:text => text).set
        end

        def list_item_height
          Functions.send_message(hwnd, Constants::CB_GETITEMHEIGHT, 0 ,nil)
        end

        def dropbox_boundary
          boundary = FFI::MemoryPointer.new :long, 4

          Functions.send_message(hwnd, Constants::CB_GETDROPPEDCONTROLRECT, 0 ,boundary)

          boundary.read_array_of_long(4)
        end

        def get_top_index
          Functions.send_message(hwnd, Constants::CB_GETTOPINDEX, 0 ,nil)
        end

        private

        def item_count
          Functions.send_message(hwnd, Constants::CB_GETCOUNT, 0, nil)
        end

      end
    end
  end
end
