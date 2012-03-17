module RAutomation
  module Adapter
    module Win32
      class Mouse
        def initialize(window)
          @window = window
        end

        def move(coords={})
          @last_position = coords = (@last_position || position).merge(coords)

          until position[:x] == coords[:x] && position[:y] == coords[:y]
            @window.activate
            Functions.set_cursor_pos coords[:x], coords[:y]
          end
        end

        def position
          Functions.get_cursor_pos
        end

        def click
          send_input down_event, up_event
        end

        def press
          send_input down_event
        end

        def release
          send_input up_event
        end

        private

        def send_input *inputs
          @window.activate
          Functions.send_input inputs.size, inputs.join, inputs[0].size
        end

        def down_event
          input Constants::MOUSEEVENTF_LEFTDOWN
        end

        def up_event
          input Constants::MOUSEEVENTF_LEFTUP
        end

        def input flag
          mouse_input = Array.new(7, 0)
          mouse_input[0] = Constants::INPUT_MOUSE
          mouse_input[4] = flag
          mouse_input.pack "L*"
        end

      end
    end
  end
end
