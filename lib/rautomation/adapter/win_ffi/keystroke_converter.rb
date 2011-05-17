module RAutomation
  module Adapter
    module WinFfi
      class KeystrokeConverter

        def convertKeyCodes(input)
          codes = []

          input.scan(/(\w+)/).map do |element|
            item = element[0]
            case item
            when "tab"
              codes.push Constants::VK_TAB
            when "backspace"
              codes.push Constants::VK_BACK
            when "enter"
              codes.push Constants::VK_RETURN
            when "space"
              codes.push Constants::VK_SPACE
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
