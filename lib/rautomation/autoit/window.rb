module RAutomation
  module AutoIt
    class Window
      include WaitHelper

      class << self
        def autoit
          @@autoit
        end

        def load_autoit
          @@autoit = WIN32OLE.new('AutoItX3.Control')
        rescue WIN32OLERuntimeError
          dll = File.dirname(__FILE__) + "/../../../ext/AutoItX/AutoItX3.dll"
          system("regsvr32.exe /s #{dll.gsub('/', '\\')}")
          @@autoit = WIN32OLE.new('AutoItX3.Control')
        end
      end

      load_autoit
      attr_reader :locator

      def initialize(window_locator)
        @locator = case window_locator
          when Regexp
            "[REGEXPTITLE:#{window_locator}]"
          when Fixnum
            "[HANDLE:#{window_locator.to_s(16)}]"
          else
            window_locator
        end
      end

      def hwnd
        @hwnd ||= (handle = @@autoit.WinGetHandle(@locator).hex) != 0 ? handle : nil
      end

      def title
        @@autoit.WinGetTitle(locator_hwnd)
      end

      # makes window active
      def activate
        @@autoit.WinWait(locator_hwnd, "", 1)
        @@autoit.WinActivate(locator_hwnd)
      end

      def active?
        @@autoit.WinActive(locator_hwnd) == 1
      end

      def text
        @@autoit.WinGetText(locator_hwnd)
      end

      def exists?
        @@autoit.WinExists(locator_hwnd) == 1
      end

      def visible?
        @@autoit.WinGetState(locator_hwnd) & 2 == 2
      end

      def maximize
        @@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MAXIMIZE) == 1
      end

      def minimize
        @@autoit.WinSetState(locator_hwnd, "", @@autoit.SW_MINIMIZE) == 1
      end

      def send_keys(keys)
        wait_until do
          activate
          active?
        end
        @@autoit.Send(keys)
      end

      def close
        @@autoit.WinClose(locator_hwnd)
        @@autoit.WinKill(locator_hwnd)
      end

      def button(name)
        Button.new(self, name)
      end

      def text_field(name)
        TextField.new(self, name)
      end

      def method_missing(name, *args) #:nodoc:
        @@autoit.respond_to?(name) ? @@autoit.send(name, *args) : super
      end

      def locator_hwnd #:nodoc:
        "[HANDLE:#{hwnd.to_i.to_s(16)}]"
      end
    end
  end
end