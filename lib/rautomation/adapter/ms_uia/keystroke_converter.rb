#todo - common file, extract it

module RAutomation
  module Adapter
    module MsUia
      class KeystrokeConverter
        class << self
          def convert(str)
            special_characters = ""

            str.split(/([{}])/).inject([]) do |converted_keys, str|
              if str == "}"
                converted_keys << convert_special_characters(special_characters << str)
                special_characters = ""
              elsif str == "{" || !special_characters.empty?
                special_characters << str
              else
                converted_keys += convert_characters(str)
              end
              converted_keys
            end.flatten
          end

          private

          def convert_special_characters chars
            case chars.downcase
              when "{tab}"
                Constants::VK_TAB
              when "{backspace}"
                Constants::VK_BACK
              when "{enter}"
                Constants::VK_RETURN
              when "{left}"
                Constants::VK_LEFT
              when "{right}"
                Constants::VK_RIGHT
              when "{down}"
                Constants::VK_DOWN
              when "{up}"
                Constants::VK_UP
              when "{home}"
                Constants::VK_HOME
              when "{end}"
                Constants::VK_END
              when "{delete}"
                Constants::VK_DELETE
              when "{pgdown}"
                Constants::VK_NEXT
              when "{pgup}"
                Constants::VK_PRIOR
              else
                # unsupported special tag, ignore the tag itself, but convert the
                # characters inside the tag
                convert_characters(chars.gsub(/[{}]/, ""))
            end
          end

          private

          def convert_characters(element)
            element.split(//).inject([]) do |chars, char|
              char_code = char.upcase.unpack("c")[0]
              case char
                when "!"
                  chars += in_upcase(49)
                when "@"
                  chars += in_upcase(50)
                when "\#"
                  chars += in_upcase(51)
                when "$"
                  chars += in_upcase(52)
                when "%"
                  chars += in_upcase(53)
                when "^"
                  chars += in_upcase(54)
                when "&"
                  chars += in_upcase(55)
                when "*"
                  chars += in_upcase(56)
                when "("
                  chars += in_upcase(57)
                when ")"
                  chars += in_upcase(48)
                when "\""
                  chars += in_upcase(0xDE)
                when "'"
                  chars << 0xDE
                when "/"
                  chars << 0xBF
                when "-"
                  chars << 0xBD
                when ","
                  chars << 0xBC
                when "'"
                  chars << 0xDE
                when "&"
                  chars += in_upcase(0x37)
                when "_"
                  chars += in_upcase(0xBD)
                when "<"
                  chars += in_upcase(0xBC)
                when ">"
                  chars += in_upcase(0xBE)
                else
                  if char =~ /[A-Z]/
                    chars += in_upcase(char_code)
                  else
                    chars << char_code
                  end
              end
            end
          end

          def in_upcase(char_code)
            [Constants::VK_LSHIFT, char_code]
          end
        end
      end
    end
  end
end
