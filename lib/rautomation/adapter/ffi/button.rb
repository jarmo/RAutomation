module RAutomation
  module Adapter
    module Ffi
      class Button
        include WaitHelper
        include Locators

        # Creates the button object.
        # @note this method is not meant to be accessed directly, but only through {RAutomation::Window#button}!
        # @param [RAutomation::Window] window this button belongs to.
        # @param [Hash] locators for searching the button.
        # @option locators [String, Regexp] :value Value (text) of the button
        # @option locators [String, Regexp] :class Internal class name of the button
        # @option locators [String, Fixnum] :id Internal ID of the button
        # @option locators [String, Fixnum] :index 0-based index to specify n-th button if all other criteria match
        # @see RAutomation::Window#button
        def initialize(window, locators)
          @window = window
          extract(locators)
        end

        # @see RAutomation::Button#click
        def click
          clicked = false
          wait_until do
            hwnd = Functions.control_hwnd(@window.hwnd, @locators)
            @window.activate
            @window.active? &&
                    Functions.set_control_focus(hwnd) &&
                    Functions.control_click(hwnd) &&
                    clicked = true # is clicked at least once
            clicked && !exists?
          end
        end

        # @see RAutomation::Button#value
        def value
          Functions.control_value(Functions.control_hwnd(@window.hwnd, @locators))
        end

        # @see RAutomation::Button#exists?
        def exists?
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

      end
    end
  end
end