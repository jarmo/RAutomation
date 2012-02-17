module RAutomation
  module Adapter
    module Win32
      class ListBox < Control
        include WaitHelper
        include Locators

        # Default locators used for searching buttons.
        DEFAULT_LOCATORS = {:class => /listbox/i}

        def count
          Functions.send_message(hwnd, Constants::LB_GETCOUNT, 0, nil)
        end

        alias_method :size, :count

        def items
          count.times.reduce([]) do |memo, i|
            text_length = Functions.send_message(hwnd, Constants::LB_GETTEXTLEN, 0, nil) + 1
            text = FFI::MemoryPointer.new :char, text_length
            Functions.send_message(hwnd, Constants::LB_GETTEXT, i, text)
            memo << text.read_string
          end
        end

        alias_method :strings, :items

        def selected?(i)
          Functions.send_message(hwnd, Constants::LB_GETSEL, i, nil) > 0
        end

        def select(i)
          Functions.send_message(hwnd, Constants::LB_SETCURSEL, i, nil)
        end

      end
    end
  end
end

