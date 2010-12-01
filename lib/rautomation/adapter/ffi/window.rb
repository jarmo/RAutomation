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
          @hwnd ||= Functions.window_hwnd(@locators)
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
          result = hwnd && Functions.window_exists(hwnd)
          !!result
        end

        def visible? #:nodoc:
          Functions.window_visible(hwnd)
        end

        def maximize #:nodoc:
          Functions.show_window(hwnd, Constants::SW_MAXIMIZE)
          sleep 1
        end

        def minimize #:nodoc:
          Functions.show_window(hwnd, Constants::SW_MINIMIZE)
          sleep 1
        end

        def minimized?
          Functions.minimized(hwnd)
        end

        def restore
          Functions.show_window(hwnd, Constants::SW_RESTORE)
          sleep 1
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
          Functions.close_window(hwnd)
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
      end
    end
  end
end