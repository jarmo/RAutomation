module RAutomation
  module Adapter
    module MsUiAutomation
      # @private
      module Locators

        private

        def extract(locators)
          # windows locators
          @automation_id = locators[:automation_id].to_s if locators[:automation_id]
          @locators = locators
        end
      end
    end
  end
end
