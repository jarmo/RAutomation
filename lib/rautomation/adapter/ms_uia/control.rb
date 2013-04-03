module RAutomation
  module Adapter
    module MsUia
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

        #todo - replace with UIA version
        def hwnd
          Functions.control_hwnd(@window.hwnd, @locators)
        end

        def uia_element
          case
            when @locators[:focus]
              uia_control = UiaDll::get_focused_element
              begin
                uia_control.read_pointer
              rescue FFI::NullPointerError => e
                raise UnknownElementException, "Focused element does not exist"
              end
            when @locators[:id]
              uia_window = UiaDll::element_from_handle(@window.hwnd)
              uia_control = UiaDll::find_child_by_id(uia_window, @locators[:id].to_s)
              begin
                uia_control.read_pointer
              rescue FFI::NullPointerError => e
                raise UnknownElementException, "#{@locators[:id]} does not exist"
              end
            when @locators[:point]
              uia_control = UiaDll::element_from_point(@locators[:point][0], @locators[:point][1])
              begin
                uia_control.read_pointer
              rescue FFI::NullPointerError => e
                raise UnknownElementException, "#{@locators[:point]} does not exist"
              end
            else
              handle= hwnd
              raise UnknownElementException, "Element with #{@locators.inspect} does not exist" if (handle == 0) or (handle == nil)
              uia_control = UiaDll::element_from_handle(handle)
          end
          uia_control
        end


        #todo - replace with UIA version
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
            UiaDll::exists?(@window.hwnd, @locators) || !!hwnd
          rescue UnknownElementException
            false
          end
        end

        def enabled?
          !disabled?
        end

        #todo - replace with UIA version
        def disabled?
          Functions.unavailable?(hwnd)
        end

        #todo - replace with UIA version
        def focused?
          Functions.has_focus?(hwnd)
        end

        def focus
          assert_enabled
          uia_control = UiaDll::element_from_handle(hwnd)
          UiaDll::set_focus(uia_control)
        end

        def bounding_rectangle
          UiaDll::bounding_rectangle(@window.hwnd, @locators)
        end

        def visible?
          element = UiaDll::element_from_handle(hwnd)

          off_screen = FFI::MemoryPointer.new :int

          if UiaDll::is_offscreen(element, off_screen) == 0
            fail "Could not check element"
          end

#          puts "return #{off_screen.read_int}"
          if off_screen.read_int == 0
            return true
          end
          false
        end

        def matches_type?(*classes)
          classes.include? get_current_control_type
        end

        def get_current_control_type
          UiaDll::current_control_type(uia_element)
        end

        def new_pid
          UiaDll::current_process_id(uia_element)
        end

        def control_name
          uia_control = uia_element
          element_name = FFI::MemoryPointer.new :char, UiaDll::get_name(uia_control, nil) + 1

          UiaDll::get_name(uia_control, element_name)
          element_name.read_string
        end

        def control_class
          uia_control = uia_element
          element_class = FFI::MemoryPointer.new :char, UiaDll::get_class_name(uia_control, nil) + 1

          UiaDll::get_class_name(uia_control, element_class)
          element_class.read_string
        end

        alias_method :exists?, :exist?

        def assert_enabled
          raise "Cannot interact with disabled control #{@locators.inspect} on window #{@window.locators.inspect}!" if disabled?
        end

        def expand(which_item)
          UiaDll::expand_by_value hwnd, which_item if which_item.is_a? String
          UiaDll::expand_by_index hwnd, which_item if which_item.is_a? Integer
        end

        def collapse(which_item)
          UiaDll::collapse_by_value hwnd, which_item if which_item.is_a? String
          UiaDll::collapse_by_index hwnd, which_item if which_item.is_a? Integer
        end

      end
    end
  end
end
