module RAutomation
  module Adapter
    module MsUia
      autoload :UiaDll, File.dirname(__FILE__) + "/uia_dll"

      class Window
        include WaitHelper
        include Locators
        extend ElementCollections

        has_many :controls

        #todo - figure out what this is for and see if MsUia still needs it
        class << self
          def oleacc_module_handle
            @oleacc_module_handle ||= begin
              oleacc = Functions.load_library "oleacc.dll"
              Functions.co_initialize nil
              oleacc
            end
          end
        end

        # Locators of the window.
        attr_reader :locators

        # Possible locators are :title, :text, :hwnd, :pid, :class and :index.
        #todo - update list of valid locators for UIA
        # Creates the window object.
        # @note this method is not meant to be accessed directly, but only through {RAutomation::Window#initialize}!
        # @param [Hash] locators for searching the window.
        # @option locators [String, Regexp] :title Title of the window
        # @option locators [String, Regexp] :text Visible text of the window
        # @option locators [String, Regexp] :class Internal class name of the window
        # @option locators [String, Fixnum] :hwnd Window handle in decimal format
        # @option locators [String, Fixnum] :pid Window process ID (PID)
        # @option locators [String, Fixnum] :index 0-based index to specify n-th window if all other criteria match
        #   all other criteria match
        # @see RAutomation::Window#initialize
        def initialize(locators)
          extract(locators)
        end


        def element
          puts "finding element with #{@locators.inspect}"

          case
            when @locators[:focus]
              uia_control = UiaDll::get_focused_element
            when @locators[:id]
              uia_control = UiaDll::find_window(@locators[:id].to_s)
              raise UnknownElementException, "#{@locators[:id]} does not exist" if uia_control.nil?
            when @locators[:point]
              uia_control = UiaDll::element_from_point(@locators[:point][0], @locators[:point][1])
              raise UnknownElementException, "#{@locators[:point]} does not exist" if uia_control.nil?
            else
              hwnd = find_hwnd(locators, window_hwnd) do |hwnd|
                locators_match?(locators, control_properties(hwnd, locators))
              end
              raise UnknownElementException, "Element with #{locators.inspect} does not exist" if (hwnd == 0) or (hwnd == nil)
              uia_control = UiaDll::element_from_handle(hwnd)
          end
          uia_control
        end

        #todo - replace with UIA version
        # Retrieves handle of the window.
        # @note Searches only for visible windows.
        # @see RAutomation::Window#hwnd
        def hwnd
          @hwnd ||= Functions.window_hwnd(@locators)
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#pid
        def pid
#          puts "finding pid"

          value = Functions.window_pid(hwnd)
#          value = UiaDll::current_process_id(element)

#          puts "pid found"
          value
        end

        def new_pid
          puts "finding pid"

#                  value = Functions.window_pid(hwnd)
          value = UiaDll::current_process_id(uia_control())

          puts "pid found"
          value
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#title
        def title
          Functions.window_title(hwnd)
        end

        def bounding_rectangle
          window = UiaDll::element_from_handle(hwnd)

          boundary = FFI::MemoryPointer.new :long, 4
          UiaDll::bounding_rectangle(window, boundary)

          boundary.read_array_of_long(4)
        end

        def move_mouse(x, y)
          UiaDll::move_mouse(x, y)
        end

        def click_mouse()
          UiaDll::click_mouse
        end

        # @see RAutomation::Window#activate
        def activate
          return if !exists? || active?
          restore if minimized?
          Functions.activate_window(hwnd)
          restore if minimized?
          sleep 1
        end

        #todo - replace with UIA version
        #Why are these different?
        # @see RAutomation::Window#activate
#        def activate
#          return if !exists? || active?
#          Functions.activate_window(hwnd)
#         restore if minimized?
#         sleep 1
#        end


        #todo - replace with UIA version
        # @see RAutomation::Window#active?
        def active?
          exists? && Functions.foreground_window == hwnd
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#text
        def text
          Functions.window_text(hwnd)
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#exists?
        def exists?
          result = hwnd && Functions.window_exists(hwnd)
          !!result
#          puts "calling sub exists?"
#          p = !!pid
#          puts "exists? complete"
          #         p
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#visible?
        def visible?
          Functions.window_visible(hwnd)
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#maximize
        def maximize
          Functions.show_window(hwnd, Constants::SW_MAXIMIZE)
          sleep 1
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#minimize
        def minimize
          Functions.show_window(hwnd, Constants::SW_MINIMIZE)
          sleep 1
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#minimized?
        def minimized?
          Functions.minimized(hwnd)
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#restore
        def restore
          Functions.show_window(hwnd, Constants::SW_RESTORE)
          sleep 1
        end

        #todo - replace with UIA version if possible
        # Activates the window and sends keys to it.
        #
        # Refer to KeystrokeConverter#convert_special_characters for the special keycodes.
        # @see RAutomation::Window#send_keys
        def send_keys(keys)
          shift_pressed = false
          KeystrokeConverter.convert(keys).each do |key|
            wait_until do
              activate
              active?
            end
            press_key key

            if key == Constants::VK_LSHIFT
              shift_pressed = true
              next
            end

            release_key key

            if shift_pressed
              shift_pressed = false
              release_key Constants::VK_LSHIFT
            end
          end
        end


        def display_tree
          root_element = UiaDll::element_from_handle(hwnd)

          root_name = FFI::MemoryPointer.new :char, UiaDll::get_name(root_element, nil) + 1
          UiaDll::get_name(root_element, root_name)

          [root_name.read_string.inspect, gather_children(root_element)]
        end

        def gather_children(root_element)
          element_tree = []

          child_count = count_children(root_element)
          children = FFI::MemoryPointer.new :pointer, child_count
          UiaDll::find_children(root_element, children)

          children.read_array_of_pointer(child_count).each do |child|
            child_name = FFI::MemoryPointer.new :char, UiaDll::get_name(child, nil) + 1
            UiaDll::get_name(child, child_name)

            grandchild_count = count_children(child)

            if grandchild_count > 0
              element_tree << [child_name.read_string, gather_children(child)]
            else
              element_tree << child_name.read_string
            end
          end

          element_tree
        end

        def count_children(element)
          UiaDll::find_children(element, nil)
        end

        def class_names
          root_element = UiaDll::element_from_handle(hwnd)

          root_class = FFI::MemoryPointer.new :char, UiaDll::get_class_name(root_element, nil) + 1
          UiaDll::get_class_name(root_element, root_class)

          classes = gather_children_classes(root_element)
          classes = classes.flatten
          classes.delete("")
          classes.sort
        end

        def gather_children_classes(root_element)
          element_tree = []

          child_count = count_children(root_element)
          children = FFI::MemoryPointer.new :pointer, child_count
          UiaDll::find_children(root_element, children)

          children.read_array_of_pointer(child_count).each do |child|
            child_name = FFI::MemoryPointer.new :char, UiaDll::get_class_name(child, nil) + 1
            UiaDll::get_class_name(child, child_name)

            grandchild_count = count_children(child)

            if grandchild_count > 0
              element_tree << [child_name.read_string, gather_children_classes(child)]
            else
              element_tree << child_name.read_string
            end
          end

          element_tree
        end

        def get_focused_element
          UiaDll::get_focused_element()
        end

        #todo - replace with UIA version
        # @see RAutomation::Window#close
        def close
          Functions.close_window(hwnd)
        end

        # @see Button#initialize
        # @see RAutomation::Window#button
        def button(locator)
          Button.new(self, locator)
        end

        # @see TextField#initialize
        # @see RAutomation::Window#text_field
        def text_field(locator)
          TextField.new(self, locator)
        end

        def label(locator)
          Label.new(self, locator)
        end

        def control(locator)
          Control.new(self, locator)
        end

        def controls(locator)
          Controls.new(self, locator)
        end

        def list_box(locator)
          ListBox.new(self, locator)
        end

        def list_item(locator)
          ListItem.new(self, locator)
        end

        # Redirects all method calls not part of the public API to the {Functions} directly.
        # @see RAutomation::Window#method_missing
        def method_missing(name, *args)
          Functions.respond_to?(name) ? Functions.send(name, *args) : super
        end

        #todo - why is the class extended like this?
        # extend public API
        RAutomation::Window.class_eval do
          def select_list(locator)
            wait_until_exists
            RAutomation::Adapter::MsUia::SelectList.new(@window, locator)
          end

          def checkbox(locator)
            wait_until_exists
            RAutomation::Adapter::MsUia::Checkbox.new(@window, locator)
          end

          def radio(locator)
            wait_until_exists
            RAutomation::Adapter::MsUia::Radio.new(@window, locator)
          end

          def table(locator)
            wait_until_exists
            RAutomation::Adapter::MsUia::Table.new(@window, locator)
          end

          #todo - replace with UIA version
          # Creates the child window object.
          # @note This is an Win32 adapter specific method, not part of the public API
          # @example
          #   RAutomation::Window.new(:title => /Windows Internet Explorer/i).
          #     child(:title => /some popup/)
          # @param (see Window#initialize)
          # @return [RAutomation::Window] child window, popup or regular window.
          def child(locators)
            RAutomation::Window.new Functions.child_window_locators(@window.hwnd, locators)
          end
        end

#        private

        #todo - replace with UIA versions if possible

        def press_key key
          Functions.send_key(key, 0, 0, nil)
        end

        def release_key key
          Functions.send_key(key, 0, Constants::KEYEVENTF_KEYUP, nil)
        end
      end
    end
  end
end
