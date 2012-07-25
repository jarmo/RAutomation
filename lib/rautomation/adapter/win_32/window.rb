module RAutomation
  module Adapter
    module Win32
      class Window
        include WaitHelper
        include Locators
        extend ElementCollections

        has_many :controls

        class << self
          def oleacc_module_handle
            @oleacc_module_handle ||= begin
              oleacc = Functions.load_library "oleacc.dll"
              Functions.co_initialize nil
              oleacc
            end
          end
        end

        attr_reader :container

        # Locators of the window.
        attr_reader :locators

        # Possible locators are :title, :text, :hwnd, :pid, :class and :index.

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
        def initialize(container, locators)
          @container = container
          extract(locators)
        end

        # Retrieves handle of the window.
        # @note Searches only for visible windows.
        # @see RAutomation::Window#hwnd
        def hwnd
          @hwnd ||= Functions.window_hwnd(@locators)
        end

        # @see RAutomation::Window#pid
        def pid
          Functions.window_pid(hwnd)
        end

        # @see RAutomation::Window#title
        def title
          Functions.window_title(hwnd)
        end

        # @see RAutomation::Window#class_names
        def class_names
          classes = []
          controls.each do |control|
            classes << control.class_name
          end
          classes.sort
        end

        # @see RAutomation::Window#activate
        def activate
          return if !exists? || active?
          restore if minimized?
          Functions.activate_window(hwnd)
          sleep 0.1
        end

        # @see RAutomation::Window#active?
        def active?
          exists? && Functions.foreground_window == hwnd
        end

        # @see RAutomation::Window#text
        def text
          Functions.window_text(hwnd)
        end

        # @see RAutomation::Window#exists?
        def exists?
          result = hwnd && Functions.window_exists(hwnd)
          !!result
        end

        # @see RAutomation::Window#visible?
        def visible?
          Functions.window_visible(hwnd)
        end

        # @see RAutomation::Window#maximize
        def maximize
          Functions.show_window(hwnd, Constants::SW_MAXIMIZE)
          sleep 1
        end

        # @see RAutomation::Window#minimize
        def minimize
          Functions.show_window(hwnd, Constants::SW_MINIMIZE)
          sleep 1
        end

        # @see RAutomation::Window#minimized?
        def minimized?
          Functions.minimized(hwnd)
        end

        # @see RAutomation::Window#restore
        def restore
          Functions.show_window(hwnd, Constants::SW_RESTORE)
          sleep 1
        end

        # Moves/resizes the window. 
        # @note All coordinates are optional and if not specified current coordinates will be used
        # @param [Hash] coords for specifying the coordinates.
        # @option coords [Fixnum] :left Window coordinate from the left side of screen
        # @option coords [Fixnum] :top Window coordinate from the top of the screen
        # @option coords [Fixnum] :width Width of window
        # @option coords [Fixnum] :height Height of window
        def move(coords={})
          @container.wait_until_present
          rect = dimensions.merge(coords)
          Functions.move_window(hwnd, rect[:left], rect[:top], rect[:width], rect[:height])
          sleep 1
        end

        # @return [Hash] Hash[:left, :top, :width, :height] with window coordinates
        def dimensions
          @container.wait_until_present
          left, top, right, bottom = Functions.window_rect(hwnd)
          {:left => left, :top => top, :width => right - left, :height => bottom - top}
        end


        # Activates the window and sends keys to it.
        #
        # @example
        #   RAutomation::Window.new(:title => //).send_keys "hello!"
        #   RAutomation::Window.new(:title => //).send_keys [:control, "a"], "world!"
        # Refer to {Keys::KEYS} for all the special keycodes.
        # @see RAutomation::Window#send_keys
        def send_keys(args)
          Keys.encode(args).each do |arg|
            wait_until do
              activate
              active?
            end

            if arg.is_a?(Array)
              arg.reduce([]) do |pressed_keys, k|
                if k == Keys[:null]
                  pressed_keys.each {|pressed_key| release_key pressed_key}
                  pressed_keys = []
                else
                  pressed_keys << press_key(k)
                end
                pressed_keys
              end
            else
              send_key arg
            end
          end
          sleep 1
        end

        # @see RAutomation::Window#close
        def close
          Functions.close_window(hwnd)
        end

        # Retrieves the {Mouse} object for automating mouse movements and clicks
        # @raise [UnknownWindowException] if the window doesn't exist.
        def mouse
          @container.wait_until_present
          Mouse.new(self)
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

        # Redirects all method calls not part of the public API to the {Functions} directly.
        # @see RAutomation::Window#method_missing
        def method_missing(name, *args)
          Functions.respond_to?(name) ? Functions.send(name, *args) : super
        end

        # Win32 adapter specific API methods
        def label(locator={})
          @container.wait_until_present
          Label.new(self, locator)
        end

        def password_field(locator)
          @container.wait_until_present
          PasswordField.new(self, locator)
        end

        def control(locator={})
          @container.wait_until_present
          Control.new(self, locator)
        end

        def list_box(locator={})
          @container.wait_until_present
          ListBox.new(self, locator)
        end

        def select_list(locator={})
          @container.wait_until_present
          SelectList.new(self, locator)
        end

        def checkbox(locator={})
          @container.wait_until_present
          Checkbox.new(self, locator)
        end

        def radio(locator={})
          @container.wait_until_present
          Radio.new(self, locator)
        end

        def table(locator={})
          @container.wait_until_present
          Table.new(self, locator)
        end

        # Creates the child window object.
        # @note This is an Win32 adapter specific method, not part of the public API
        # @example
        #   RAutomation::Window.new(:title => /Windows Internet Explorer/i).
        #     child(:title => /some popup/)
        # @param (see Window#initialize)
        # @return [RAutomation::Window] child window, popup or regular window.
        def child(locators)
          RAutomation::Window.new Functions.child_window_locators(hwnd, locators)
        end

        private

        def press_key key
          Functions.send_key(key, 0, 0, nil)
          key
        end

        def release_key key
          Functions.send_key(key, 0, Constants::KEYEVENTF_KEYUP, nil)
          key
        end

        def send_key key
          press_key key
          release_key key
          key
        end
      end
    end
  end
end
