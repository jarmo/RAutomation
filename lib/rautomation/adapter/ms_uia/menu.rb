module RAutomation
  module Adapter
    module MsUia
      class Menu
        attr_reader :menu_items
        attr_reader :window

        def initialize(window, locator)
          @menu_items = [] << locator[:text]
          @window = window
        end

        def menu(locator)
          @menu_items << locator[:text]
          self
        end

        def exists?
          UiaDll::menu_item_exists window.hwnd, *menu_items_arg
        end

        def open
          error_info = FFI::MemoryPointer.new :char, 1024
          UiaDll::select_menu_item window.hwnd, error_info, 1024, *menu_items_arg
          error = error_info.get_string 0
          raise error unless error.empty?
        end

        private
        def menu_items_arg
          menu_items.map {|s| [:string, s]}.flatten << :pointer << nil
        end
      end
    end
  end
end
