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
              if !Functions.window_visible(hwnd) || Functions.window_text(hwnd).empty?
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

            Functions.enum_windows(window_callback, nil)
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
          closed = Functions.send_message_timeout(hwnd, Constants::WM_CLOSE,
                                                  0, nil, Constants::SMTO_ABORTIFHUNG, 1000, nil)
          # force it to close
          unless closed
            pid = FFI::MemoryPointer.new :int
            Functions.window_thread_process_id(hwnd, pid)
            process_hwnd = Functions.open_process(Constants::PROCESS_ALL_ACCESS, false, pid.read_int)
            Functions.terminate_process(process_hwnd, 0)
            Functions.close_handle(process_hwnd)
          end
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
          @locators.inject({}) do |properties, locator|
            properties[locator[0]] = Functions.send("window_#{locator[0]}", hwnd)
            properties
          end
        end
      end
    end
  end
end