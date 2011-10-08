module RAutomation
  module Adapter
    module WinFfi
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

        def click
          assert_enabled
          clicked = false
          wait_until do
            @window.activate
            @window.active? &&
                Functions.set_control_focus(hwnd) &&
                Functions.control_click(hwnd) &&
                clicked = true # is clicked at least once

            block_given? ? yield : clicked && !exist?
          end
        end

        def exist?
          begin
            !!hwnd
          rescue UnknownElementException
            false
          end
        end

        def enabled?
          !disabled?
        end

        def disabled?
          Functions.unavailable?(hwnd)
        end

        def has_focus?
          Functions.has_focus?(hwnd)
        end

        def set_focus
          assert_enabled
          uia_control = UiaDll::element_from_handle(hwnd)
          UiaDll::set_focus(uia_control)
        end

        def uia_control(automation_id)
          uia_window = UiaDll::element_from_handle(@window.hwnd) # finds IUIAutomationElement for given parent window
          uia_element = UiaDll::find_child_by_id(uia_window, automation_id.to_s)
          fail "Cannot find UIAutomationElement" if uia_element.nil?
          uia_element
        end

        def bounding_rectangle
          element = UiaDll::element_from_handle(hwnd)

          boundary = FFI::MemoryPointer.new :long, 4
          UiaDll::bounding_rectangle(element, boundary)

          boundary.read_array_of_long(4)
        end

        def matches_type?(clazz)
          get_current_control_type == clazz
        end

        def get_current_control_type
          uia_control = UiaDll::element_from_handle(hwnd)
          UiaDll::current_control_type(uia_control)
        end

        alias_method :exists?, :exist?

        def assert_enabled
          raise "Cannot interact with disabled control #{@locators.inspect} on window #{@window.locators.inspect}!" if disabled?
        end
      end
    end
  end
end
