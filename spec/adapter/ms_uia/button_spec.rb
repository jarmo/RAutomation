require 'spec_helper'

describe "MsUia::Button", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]) }
  it "find by id" do
    expect(window.button(id: "aboutButton").exist?).to be true
  end

  it "check for button class" do
    expect(window.button(id: "textField").exist?).to_not be true
  end


  it "enabled/disabled" do
    expect(window.button(id: "enabledButton").enabled?).to be true
    expect(window.button(id: "enabledButton").disabled?).to_not be be true

    expect(window.button(id: "disabledButton").disabled?).to be true
    expect(window.button(id: "disabledButton").enabled?).to_not be true
  end

  it "#focus" do
    button = window.button(id: "enabledButton")
    expect(button.focused?).to_not be true

    button.focus
    expect(button.focused?).to be true
  end

  it "cannot click disabled button" do
    expect { window.button(id: "disabledButton").click }.to raise_error(RuntimeError)
  end

  it "cannot set focus to disabled button" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect { window.button(id: "disabledButton").focus }.to raise_error(RuntimeError)
  end

end