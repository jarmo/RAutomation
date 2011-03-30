module RAutomation
  module Adapter
    module WinFfi
      class KeystrokeConverter

        def convertKeyCodes(input)
          codes = []

          input.scan(/(\w+)/).map do |element|
            item = element[0]
            if "tab".eql? item
              codes.push Constants::VK_TAB
            elsif "backspace".eql? item
              codes.push Constants::VK_BACK
            elsif "enter".eql? item
              codes.push Constants::VK_RETURN
            else
              convertCharacters codes, item
            end
          end

          codes
        end

        private

        def convertCharacters(codes, element)
          element.split(//).each do |character|
            codes.push character.ord
          end
        end

      end
    end
  end
end
