#todo - some files are common between Win32 and MsUia adapter, consider pulling out to shared location

module RAutomation
  module Adapter
    module MsUia
      module Locators

        private

        def extract(locators)
          # windows locators
          @hwnd = locators[:hwnd].to_i if locators[:hwnd]
          locators[:pid] = locators[:pid].to_i if locators[:pid]
          locators[:index] = locators[:index].to_i if locators[:index]

          # control locator
          locators = self.class::DEFAULT_LOCATORS.merge(locators) if self.class.const_defined?(:DEFAULT_LOCATORS)
          @locators = {:index => 0}.merge locators
        end
      end
    end
  end
end
