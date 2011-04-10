unless String.instance_methods.include? :ord
  class String
    def ord
      [0]
    end
  end
end

module RAutomation
  module Adapter
    module WinFfi
      class KeystrokeConverter
        class << self
          def convert(input)
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
                codes += convert_characters(item)
              end
            end

            codes
          end

          private

          def convert_characters(element)
            element.split(//).inject([]) {|chars, char| chars << char.ord}
          end

        end
      end
    end
  end
end
