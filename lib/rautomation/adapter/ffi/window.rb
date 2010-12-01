module RAutomation
  module Adapter
    module Ffi
      class Window

        attr_reader :locators

        # Possible locators are :title, :text, :hwnd and :class.
        def initialize(locators)
          @hwnd = locators.delete(:hwnd)
          @locators = locators
        end

        # Returns handle of the found window.
        # Searches only for visible windows with having some text at all.
        def hwnd #:nodoc:
          @hwnd ||= begin
            found_hwnd = nil
            window_callback = FFI::Function.new(:bool, [:long, :pointer], {:convention => :stdcall}) do |hwnd, _|
              if !Functions._window_visible(hwnd) || Functions.window_text(hwnd).empty?
                true
              else
                properties = window_properties(hwnd)
                locators_match = @locators.all? do |locator, value|
                  if value.is_a?(Regexp)
                    properties[locator] =~ value
                  else
                    properties[locator] == value
                  end
                end

                if locators_match
                  found_hwnd = hwnd
                  false
                else
                  true
                end
              end
            end

            Functions._enum_windows(window_callback, nil)
            found_hwnd
          end
        end

        def title #:nodoc:
          Functions.window_title(hwnd)
        end

        def activate #:nodoc:
          #@@autoit.WinWait(locator_hwnd, "", 1)
          #@@autoit.WinActivate(locator_hwnd)
          #sleep 1
        end

        def active? #:nodoc:
          #@@autoit.WinActive(locator_hwnd) == 1
        end

        def text #:nodoc:
          Functions.window_text(hwnd)
        end

        def exists? #:nodoc:
          result = hwnd && Functions._window_exists(hwnd)
          !!result
        end

        def visible? #:nodoc:
          #@@autoit.WinGetState(locator_hwnd) & 2 == 2
        end

        def maximize #:nodoc:
          #@@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MAXIMIZE)
          #sleep 1
        end

        def minimize #:nodoc:
          #@@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MINIMIZE)
          #sleep 1
        end

        def minimized?
          #@@autoit.WinGetState(locator_hwnd) & 16 == 16
        end

        def restore
          #@@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_RESTORE)
          #sleep 1
        end

        # Activates the Window and sends keys to it.
        #
        # Refer to AutoIt documentation for keys syntax.
        def send_keys(keys)
          #wait_until do
          #  restore if minimized?
          #  activate
          #  active?
          #end
          #@@autoit.Send(keys)
        end

        def close #:nodoc:
          #@@autoit.WinClose(locator_hwnd)
          #@@autoit.WinKill(locator_hwnd)
        end

        def button(locator) #:nodoc:
          Button.new(self, locator)
        end

        def text_field(locator) #:nodoc:
          TextField.new(self, locator)
        end

        def method_missing(name, *args) #:nodoc:
          #@@autoit.respond_to?(name) ? @@autoit.send(name, *args) : super
        end

        private

        def window_properties(hwnd)
          properties = {}
          @locators.each_key do |locator|
            properties[locator] = Functions.send("window_#{locator}", hwnd)
          end
          properties
        end
      end
    end
  end
end