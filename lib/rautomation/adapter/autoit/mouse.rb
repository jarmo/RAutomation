module RAutomation
  module Adapter
    module Autoit
      class Mouse
        def initialize(window)
          @window = window
          @autoit = window.class.autoit
        end

        def move(coords={})
          @last_position = coords = (@last_position || position).merge(coords)

          until position[:x] == coords[:x] && position[:y] == coords[:y]
            @window.activate
            @autoit.MouseMove(coords[:x], coords[:y])
          end
        end

        def position
          {:x => @autoit.MouseGetPosX, :y => @autoit.MouseGetPosY}
        end

        def click(button = "left")
          @autoit.MouseClick(button)
        end

        def press(button = "left")
          @autoit.MouseDown(button)
        end

        def release(button = "left")
          @autoit.MouseUp(button)
        end

      end
    end
  end
end
