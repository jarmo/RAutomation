module RAutomation
  module Adapter
    module Ffi
      module Locators

        private

        def extract(locators) #:nodoc:
          locators[:id] = locators[:id].to_i if locators[:id]
          locators[:index] = locators[:index].to_i if locators[:index]
          @locators = locators
        end
      end
    end
  end
end