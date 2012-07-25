module RAutomation
  module Adapter
    module Win32
      class PasswordField < TextField

        private

        def set?(text)
          # getting value from password field will not retrieve anything
          true
        end
      end
    end
  end
end
