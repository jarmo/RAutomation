require 'spec_helper'

describe "Win32::Checkbox", :if => SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  it "#checkbox" do
    expect(window.checkbox(:value => "checkBox")).to exist

    RAutomation::Window.wait_timeout = 0.1
    expect { RAutomation::Window.new(:title => "non-existing-window").checkbox(:value => "Something") }.
        to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set? & #set" do
    checkbox = window.checkbox(:value => "checkBox")
    expect(checkbox.set?).to be false
    checkbox.set
    expect(checkbox.set?).to be true
  end

  it "#value" do
    checkbox = window.checkbox(:value => "checkBox")
    expect(checkbox.value).to be == "checkBox"
  end

  it "#clear" do
    checkbox = window.checkbox(:value => "checkBox")
    checkbox.set
    expect(checkbox.set?).to be true

    checkbox.clear
    expect(checkbox.set?).to be false
  end

  it "enabled/disabled" do
    expect(window.checkbox(:value => "checkBox").enabled?).to be true
    expect(window.checkbox(:value => "checkBox").enabled?).to_not be false

    expect(window.checkbox(:value => "checkBoxDisabled").enabled?).to_not be true
    expect(window.checkbox(:value => "checkBoxDisabled").enabled?).to be false
  end

  it "cannot check a disabled checkbox" do
     expect { window.checkbox(:value => "checkBoxDisabled").set }.to raise_error(RuntimeError)
  end

end
