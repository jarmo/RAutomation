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

        def open
          error_info = FFI::MemoryPointer.new :char, 1024
          args = menu_items.map {|s| [:string, s]}.flatten
          UiaDll::select_menu_item window.hwnd, error_info, 1024, *args, :pointer, nil
          error = error_info.get_string 0
          raise error unless error.empty?
        end
      end
    end
  end
end
