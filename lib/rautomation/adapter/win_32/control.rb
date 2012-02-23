module RAutomation
  module Adapter
    module Win32
      class Control
        include WaitHelper
        include Locators

        # Creates the control object.
        # @note this method is not meant to be accessed directly
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

        def hwnd
          Functions.control_hwnd(@window.hwnd, @locators)
        end

        def class_name
          Functions.control_class(hwnd)
        end

        def click
          assert_enabled
          clicked = false
          wait_until do
            @window.activate
            @window.active? &&
                focus &&
                Functions.control_click(hwnd) &&
                clicked = true # is clicked at least once

            block_given? ? yield : clicked && !exist?
          end
        end

        def hwnd
          Functions.control_hwnd(@window.hwnd, @locators)
        end

        def exist?
          !!hwnd
        rescue UnknownElementException
          false
        end

        alias_method :exists?, :exist?

        def enabled?
          !disabled?
        end

        def disabled?
          Functions.unavailable? hwnd
        end

        def focus
          assert_enabled
          @window.activate
          Functions.set_control_focus hwnd
        end

        def focused?
          Functions.has_focus?(hwnd)
        end

        def value
          Functions.control_value(hwnd)
        end

        private

        def assert_enabled
          raise "Cannot interact with disabled control #{@locators.inspect} on window #{@window.locators.inspect}!" if disabled?
        end
      end
    end
  end
end
