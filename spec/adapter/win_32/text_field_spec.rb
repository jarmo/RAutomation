require 'spec_helper'

describe "Win32::TextField", :if => SpecHelper.adapter == :win_32 do
   let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  it "enabled/disabled" do
    expect(window.text_field(:index => 2).enabled?).to be true
    expect(window.text_field(:index => 2).enabled?).to_not be false
  end

  it "cannot set a value to a disabled text field" do
    expect { window.text_field(:index => 1).set "abc" }.to raise_error(RuntimeError)
    expect { window.text_field(:index => 1).clear }.to raise_error(RuntimeError)
  end

  it "#send_keys" do
    text_field = window.text_field(:index => 2)
    text_field.send_keys "abc"
    expect(text_field.value).to be == "abc"

    text_field.send_keys [:control, "a"], :backspace
    expect(text_field.value.empty?).to be true
  end

end
