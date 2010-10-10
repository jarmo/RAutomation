module RAutomation
  module Implementations
    module AutoIt
      class Window
        include WaitHelper
        include Locators

        class << self
          def autoit #:nodoc:
            @@autoit
          end

          def load_autoit #:nodoc:
            @@autoit = WIN32OLE.new('AutoItX3.Control')
          rescue WIN32OLERuntimeError
            dll = File.dirname(__FILE__) + "/../../../ext/AutoItX/AutoItX3.dll"
            system("regsvr32.exe /s #{dll.gsub('/', '\\')}")
            @@autoit = WIN32OLE.new('AutoItX3.Control')
          end
        end

        load_autoit
        @@autoit.AutoItSetOption("WinWaitDelay", 350)

        attr_reader :locators

        # Special-cased locators
        LOCATORS = {[:title, String] => :title,
                    [:title, Regexp] => :regexptitle,
                    :hwnd => :handle}

        # Possible locators are :title, :text, :hwnd and :class.
        def initialize(locators)
          @hwnd = locators[:hwnd]
          @locator_text = locators.delete(:text)
          extract(locators)
        end

        def hwnd #:nodoc:
          @hwnd ||= @@autoit.WinList(@locators, @locator_text).pop.compact.
                  find {|handle| self.class.new(:hwnd => handle.hex).visible?}.hex rescue nil
        end

        def title #:nodoc:
          @@autoit.WinGetTitle(locator_hwnd)
        end

        def activate #:nodoc:
          @@autoit.WinWait(locator_hwnd, "", 1)
          @@autoit.WinActivate(locator_hwnd)
          sleep 1
        end

        def active? #:nodoc:
          @@autoit.WinActive(locator_hwnd) == 1
        end

        def text #:nodoc:
          @@autoit.WinGetText(locator_hwnd)
        end

        def exists? #:nodoc:
          @@autoit.WinExists(locator_hwnd) == 1
        end

        def visible? #:nodoc:
          @@autoit.WinGetState(locator_hwnd) & 2 == 2
        end

        def maximize #:nodoc:
          @@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MAXIMIZE) == 1
        end

        def minimize #:nodoc:
          @@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MINIMIZE) == 1
        end

        # Activates the Window and sends keys to it.
        #
        # Refer to AutoIt documentation for keys syntax.
        def send_keys(keys)
          wait_until do
            activate
            active?
          end
          @@autoit.Send(keys)
        end

        def close #:nodoc:
          @@autoit.WinClose(locator_hwnd)
          @@autoit.WinKill(locator_hwnd)
        end

        def button(locator) #:nodoc:
          Button.new(self, locator)
        end

        def text_field(locator) #:nodoc:
          TextField.new(self, locator)
        end

        def method_missing(name, *args) #:nodoc:
          @@autoit.respond_to?(name) ? @@autoit.send(name, *args) : super
        end

        # Used internally.
        def locator_hwnd #:nodoc:
          "[HANDLE:#{hwnd.to_i.to_s(16)}]"
        end
      end
    end
  end
end