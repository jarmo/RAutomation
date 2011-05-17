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

        def click
          if enabled? then
            clicked = false
            wait_until do
              hwnd = Functions.control_hwnd(@window.hwnd, @locators)

              @window.activate
              @window.active? &&
                      Functions.set_control_focus(hwnd) &&
                      Functions.control_click(hwnd) &&
                      clicked = true # is clicked at least once

              block_given? ? yield : clicked && !exist?
            end
          else
            raise "Cannot click disabled control"
          end
        end

        def exist?
          !!Functions.control_hwnd(@window.hwnd, @locators)
        end

        def enabled?
          !Functions.unavailable?(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def disabled?
          Functions.unavailable?(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def has_focus?
          Functions.has_focus?(Functions.control_hwnd(@window.hwnd, @locators))
        end

        def set_focus
          raise "Cannot set focus to disabled control" if disabled?

          uia_control = UiaDll::element_from_handle(Functions.control_hwnd(@window.hwnd, @locators))
          UiaDll::set_focus(uia_control)
        end

        def uia_control(automation_id)
          uia_window = UiaDll::element_from_handle(@window.hwnd) # finds IUIAutomationElement for given parent window
          uia_element = UiaDll::find_child_by_id(uia_window, automation_id.to_s)
          fail "Cannot find UIAutomationElement" if uia_element.nil?
          uia_element
        end

        alias_method :exists?, :exist?

      end
    end
  end
end
