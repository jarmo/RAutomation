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
        @locator =
                case window_locator
                  when Regexp
                    "[REGEXPTITLE:#{window_locator}]"
                  when Fixnum
                    "[HANDLE:#{window_locator.to_s(16).rjust(8, "0")}]"
                  else
                    window_locator
                end
      end

      def hwnd
        @@autoit.WinGetHandle(@locator).hex
      end

      def title
        @@autoit.WinGetTitle(@locator)
      end

      # makes window active
      def activate
        @@autoit.WinWait(@locator, "", 1)
        @@autoit.WinActivate(@locator)
      end

      def active?
        @@autoit.WinActive(@locator) == 1
      end

      def text
        @@autoit.WinGetText(@locator)
      end

      def exists?
        @@autoit.WinExists(@locator) == 1
      end

      def visible?
        @@autoit.WinGetState(@locator) & 2 == 2
      end

      def maximize
        @@autoit.WinSetState(@locator, "", @@autoit.SW_MAXIMIZE) == 1
      end

      def minimize
        @@autoit.WinSetState(@locator, "", @@autoit.SW_MINIMIZE) == 1
      end

      def send_keys(keys)
        wait_until do
          activate
          active?
        end
        @@autoit.Send(keys)
      end

      def close
        @@autoit.WinClose(@locator)
        @@autoit.WinKill(@locator)
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
    end
  end
end