require 'spec_helper'

describe "Win32::Button", if: SpecHelper.adapter == :win_32 do
  it "enabled/disabled" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])

    expect(window.button(value: "Enabled").enabled?).to be true
    expect(window.button(value: "Enabled").disabled?).to be false

    expect(window.button(value: "Disabled").enabled?).to be false
    expect(window.button(value: "Disabled").disabled?).to be true
  end

  it "#focus" do
    button = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).button(value: "Enabled")
    expect(button.focused?).to be false
    button.focus
    expect(button.focused?).to be true
  end

  it "cannot click disabled button" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect { window.button(value: "Disabled").click }.to raise_error(RuntimeError)
  end

  it "cannot set focus to disabled button" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect{ window.button(value: "Disabled").focus }.to raise_error(RuntimeError)
  end

end
