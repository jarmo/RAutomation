module RAutomation
  module Adapter
    module WinFfi
      class TextField
        include WaitHelper
        include Locators

        # Default locators used for searching text fields.
        DEFAULT_LOCATORS = {:class => "Edit"}

        # Creates the text field object.
        # @note this method is not meant to be accessed directly, but only through {RAutomation::Window#text_field}!
        # @param [RAutomation::Window] window this text field belongs to.
        # @param [Hash] locators for searching the text field.
        # @option locators [String, Regexp] :class Internal class name of the text field
        # @option locators [String, Regexp] :value Value (text) of the text field
        # @option locators [String, Fixnum] :id Internal ID of the text field
        # @option locators [String, Fixnum] :index 0-based index to specify n-th text field if all other criteria match
        # @see RAutomation::Window#text_field
        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        # @see RAutomation::TextField#set
        def set(text)
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)
            @window.activate
            @window.active? &&
                    Functions.set_control_focus(hwnd) &&
                    Functions.set_control_text(hwnd, text) &&
                    value == text
          end
        end

        # @see RAutomation::TextField#clear
        def clear
          set ""
        end

        # @see RAutomation::TextField#value
        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        # @see RAutomation::TextField#exists?
        def exists?
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

      end
    end
  end
end
