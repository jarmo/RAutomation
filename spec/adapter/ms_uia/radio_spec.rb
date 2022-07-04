require 'spec_helper'

describe "MsUia::RadioButton", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#exist?" do
    expect(window.radio(value: "Option 1").exist?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existent-window").
            radio(value: "Option 1")}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for radio class" do
    expect(window.radio(id: "textField").exist?).to_not be true
    expect(window.radio(id: "radioButton2").exist?).to be true
  end


  it "#set? & #set" do
    radio = window.radio(value: "Option 1")
    expect(radio.set?).to_not be true

    radio.set
    expect(radio.set?).to be true
  end

  it "enabled/disabled" do
    expect(window.radio(value: "Option 1").enabled?).to be true
    expect(window.radio(value: "Option 1").disabled?).to_not be true

    expect(window.radio(value: "Option Disabled").enabled?).to_not be true
    expect(window.radio(value: "Option Disabled").disabled?).to be true
  end

  it "cannot set a disabled radio button" do
    expect { window.radio(value: "Option Disabled").set }.to raise_error(RuntimeError)
  end
end
