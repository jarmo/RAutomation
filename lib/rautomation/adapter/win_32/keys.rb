module RAutomation
  module Adapter
    module Win32
      class Keys
        KEYS = {
          # keycodes from http://msdn.microsoft.com/en-us/library/ms927178.aspx
          :null          => 0x00,
          :cancel        => 0x03,
          :help          => 0x2F,
          :backspace     => 0x08,
          :tab           => 0x09,
          :clear         => 0x0C,
          :return        => 0x0D,
          :enter         => 0x0D,
          :shift         => 0x10,
          :left_shift    => 0xA0,
          :control       => 0x11,
          :left_control  => 0xA2,
          :alt           => 0x12,
          :left_alt      => 0xA4,
          :left_bracket  => 0xDB,
          :right_bracket => 0xDD,
          :single_quote  => 0xDE,
          :pause         => 0x13,
          :escape        => 0x1B,
          :space         => 0x20,
          :page_up       => 0x21,
          :page_down     => 0x22,
          :end           => 0x23,
          :home          => 0x24,
          :left          => 0x25,
          :arrow_left    => 0x25,
          :up            => 0x26,
          :arrow_up      => 0x26,
          :right         => 0x27,
          :arrow_right   => 0x27,
          :down          => 0x28,
          :arrow_down    => 0x28,
          :insert        => 0x2D,
          :delete        => 0x2E,
          :semicolon     => 0x3B,
          :equals        => 0x3D,
          :numpad0       => 0x60,
          :numpad1       => 0x61,
          :numpad2       => 0x62,
          :numpad3       => 0x63,
          :numpad4       => 0x64,
          :numpad5       => 0x65,
          :numpad6       => 0x66,
          :numpad7       => 0x67,
          :numpad8       => 0x68,
          :numpad9       => 0x69,
          :multiply      => 0x6A,
          :add           => 0x6B,
          :separator     => 0x6C,
          :subtract      => 0x6D,
          :decimal       => 0x6E,
          :divide        => 0x6F,
          :f1            => 0x70,
          :f2            => 0x71,
          :f3            => 0x72,
          :f4            => 0x73,
          :f5            => 0x74,
          :f6            => 0x75,
          :f7            => 0x76,
          :f8            => 0x77,
          :f9            => 0x78,
          :f10           => 0x79,
          :f11           => 0x7A,
          :f12           => 0x7B,
          :dash          => 0xBD,
          :slash         => 0x6F,
          :backslash     => 0xDC
        }            

        SPECIAL_KEYS = {
          "!"   => 0x31,
          "@"   => 0x32,
          "#"   => 0x33,
          "$"   => 0x34,
          "%"   => 0x35,
          "^"   => 0x36,
          "&"   => 0x37,
          "*"   => 0x38,
          "("   => 0x39,
          ")"   => 0x30,
          "_"   => 0x2D,
          "+"   => 0x3D,
          "{"   => 0x5B,
          "}"   => 0x5D,
          ":"   => 0x3B,
          "\""  => 0x27,
          "|"   => 0x5C,
          "?"   => 0x2F,
          ">"   => 0x2E,
          "<"   => 0x2C
        }

        def self.[](key)
          KEYS[key] or raise "unsupported key #{key.inspect}"
        end

        def self.encode(keys)
          keys.reduce([]) do |converted, key|
            if key.is_a?(Symbol)
              converted << Keys[key]
            elsif key.is_a?(Array)
              converted << (key.map {|k| encode([k])} << Keys[:null]).flatten
            else # key is a string
              converted += encode_str(key)
            end
            converted
          end
        end

        def self.encode_str(keys)
          keys.to_s.split("").map do |key|
            key =~ /[a-z]/ ? key.upcase.unpack("c")[0] : 
              key =~ /[A-Z]/ || SPECIAL_KEYS[key] ? [Keys[:shift], SPECIAL_KEYS[key] || key.unpack("c")[0], Keys[:null]] :
              key.unpack("c")[0]
          end
        end

      end
    end
  end
end
