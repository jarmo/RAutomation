require "spec_helper"

describe "Win32::Mouse", if: SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#click" do
    popup = RAutomation::Window.new(title: "About")
    expect(popup.present?).to_not be true

    window.maximize
    mouse = window.mouse
    mouse.move(x: 60, y: 65)
    mouse.click

    RAutomation::WaitHelper.wait_until {popup.present?}
  end

  it "#position" do
    mouse = window.mouse

    mouse.move(x: 13, y: 16)
    expect(mouse.position).to be == {x: 13, y: 16}
  end

  it "#press/#release" do
    window.maximize

    text_field = window.text_field(index: 2)
    text_field.set("start string")
    expect(text_field.value).to be == "start string"

    mouse = window.mouse
    mouse.move(x: 146, y: 125)
    mouse.press
    mouse.move(x: 194)
    mouse.release
    window.send_keys([:control, "c"])

    text_field.set("new string")
    expect(text_field.value).to be == "new string"

    mouse.move(x: 146)
    mouse.press
    mouse.move(x: 194)
    mouse.release
    window.send_keys([:control, "v"])

    expect(text_field.value).to be == "start string"
  end
end
