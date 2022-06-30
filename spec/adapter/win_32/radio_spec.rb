require 'spec_helper'

describe "Win32::RadioButton", :if => SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  it "#exist?" do
    expect(window.radio(:value => "Option 1")).to exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            radio(:value => "Option 1")}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set? & #set" do
    radio = window.radio(:value => "Option 1")
    expect(radio.set?).to_not be true

    radio.set
    expect(radio.set?).to be true
  end

  it "enabled/disabled" do
    expect(window.radio(:value => "Option 1").enabled?).to be true
    expect(window.radio(:value => "Option 1").enabled?).to_not be false

    expect(window.radio(:value => "Option Disabled").enabled?).to_not be true
    expect(window.radio(:value => "Option Disabled").enabled?).to be false
  end

  it "cannot set a disabled radio button" do
     expect { window.radio(:value => "Option Disabled").set }.to raise_error(RuntimeError)
  end
end
