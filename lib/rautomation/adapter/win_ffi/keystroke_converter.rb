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
              when "shift"
                codes.push Constants::VK_SHIFT
              when "l_shift"
                codes.push Constants::VK_LSHIFT
              when "r_shift"
                codes.push Constants::VK_RSHIFT
              when "alt"
                codes.push Constants::VK_MENU
              when "l_alt"
                codes.push Constants::VK_LMENU
              when "r_alt"
                codes.push Constants::VK_RMENU
              when "ctrl"
                codes.push Constants::VK_CONTROL
              when "l_ctrl"
                codes.push Constants::VK_LCONTROL
              when "r_ctrl"
                codes.push Constants::VK_RCONTROL
              when "caps"
                codes.push Constants::VK_CAPITAL
              when "esc"
                codes.push Constants::VK_ESCAPE
              when "end"
                codes.push Constants::VK_END
              when "home"
                codes.push Constants::VK_HOME
              when "num_lock"
                codes.push Constants::VK_NUMLOCK
              when "del"
                codes.push Constants::VK_DELETE
              when "ins"
                codes.push Constants::VK_INSERT
              else
                convertCharacters codes, item
            end
          end

          codes
        end

        def is_uppercase?(character)
          if (character.is_a?(String))
            if (character.downcase! == nil)
              false
            else
              character.upcase!
              true
            end
          else
            false
          end
        end

        private

        def convertCharacters(codes, element)
          element.split(//).each do |character|
            codes.push character[0]
          end
        end

      end
    end
  end
end
