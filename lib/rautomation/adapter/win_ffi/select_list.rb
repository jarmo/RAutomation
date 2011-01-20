module RAutomation
  module Adapter
    module WinFfi

      class SelectList < Control
        include WaitHelper
        include Locators

        class SelectListOption
          attr_accessor :text, :index, :control_hwnd

          def initialize(control_hwnd, text, index)
            @control_hwnd = control_hwnd
            @text = text
            @index = index
          end

          def selected?
            selected_idx = Functions.send_message(@control_hwnd, Constants::CB_GETCURSEL, 0, nil)
            return false if selected_idx == Constants::CB_ERR

            if (@text.eql? Functions.retrieve_combobox_item_text(@control_hwnd, selected_idx))
              true
            else
              false
            end
          end

          def select
            return false if @index == -1
            Functions.send_message(@control_hwnd, Constants::CB_SETCURSEL, @index, nil) != Constants::CB_ERR
          end
        end

        def initialize(window, locators)
          super(window, locators)
          @hwnd = Functions.control_hwnd(@window.hwnd, @locators)
        end

        def item_count
          Functions.send_message(@hwnd, Constants::CB_GETCOUNT, 0, nil)
        end

        def options(options = {})
          items = []

          0.upto(item_count - 1).each do |item_no|
            item = Functions.retrieve_combobox_item_text(@hwnd, item_no)

            if (options[:text])
              items.push(SelectListOption.new(@hwnd, item, item_no)) if options[:text].eql? item
            else
              items.push(SelectListOption.new(@hwnd, item, item_no))
            end
          end

          items
        end

      end
    end
  end
end
