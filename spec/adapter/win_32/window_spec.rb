require "spec_helper"

describe "Win32::Window", if: SpecHelper.adapter == :win_32 do
  let(:window) {RAutomation::Window.new(title: /MainFormWindow/i)}

  context "#send_keys" do
    it "send tab keystrokes to move focus between elements" do
      window.button(value: "&About").focus
      expect(window.button(value: "&About").focused?).to be true

      window.send_keys(:tab, :tab, :tab)
      button = window.button(value: "Close")
      expect(button).to exist
      expect(button.focused?).to be true
    end

    it "send arbitrary characters and control keys" do
      text_field = window.text_field(index: 2)
      text_field.focus
      arbitrary_str = "abc123ABChiHI!@#$%^&*()-_+=[{]}\\|;:'\",<.>/?`~"
      window.send_keys(arbitrary_str)
      expect(text_field.value).to be == arbitrary_str

      window.send_keys(:space, "X")
      expect(text_field.value).to be == "#{arbitrary_str} X"

      window.send_keys([:control, "a"], :backspace)
      expect(text_field.value.empty?).to be true
    end
  end

  it "#control" do
     expect(window.control(value: "&About")).to exist
  end

  it "#controls" do
     expect(window.controls(class: /button/i).size).to eq(13)
  end

  context "#move" do
    it "width=500, height=400, left=10, top=0" do
      window.move(width: 500, height: 400, left: 10, top: 0)
      coords = window.dimensions
      expect(coords[:width]).to eq(500)
      expect(coords[:height]).to eq(400)
      expect(coords[:left]).to eq(10)
      expect(coords[:top]).to eq(0)
    end

    it "uses default dimensions if not specified" do
      coords = window.dimensions
      window.move(width: 253, left: 26)

      new_coords = window.dimensions
      expect(new_coords[:width]).to eq(253)
      expect(new_coords[:left]).to eq(26)
      expect(new_coords[:top]).to eq(coords[:top])
      expect(new_coords[:height]).to eq(coords[:height])
    end
  end
end
