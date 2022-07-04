require 'spec_helper'

describe "MsUia::Checkbox", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#checkbox" do
    expect(window.checkbox(value: "checkBox").exist?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect { RAutomation::Window.new(title: "non-existing-window").checkbox(value: "Something") }.
        to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for checkbox class" do
    expect(window.checkbox(id: "textField").exist?).to_not be true
    expect(window.checkbox(id: "checkBox").exist?).to be true
  end


  it "#set? & #set" do
    checkbox = window.checkbox(value: "checkBox")
    expect(checkbox.set?).to_not be true

    checkbox.set
    expect(checkbox.set?).to be true
  end

  it "#value" do
    checkbox = window.checkbox(id: "checkBox")
    expect(checkbox.value).to be == "checkBox"
  end

  it "#clear" do
    checkbox = window.checkbox(value: "checkBox")
    checkbox.set
    expect(checkbox.set?).to be true

    checkbox.clear
    expect(checkbox.set?).to_not be true
  end

  it "enabled/disabled" do
    expect(window.checkbox(id: "checkBox").enabled?).to be true
    expect(window.checkbox(id: "checkBox").disabled?).to_not be true

    expect(window.checkbox(id: "checkBoxDisabled").enabled?).to_not be true
    expect(window.checkbox(id: "checkBoxDisabled").disabled?).to be true
  end

  it "cannot check a disabled checkbox" do
    expect {
      window.checkbox(id: "checkBoxDisabled").set
    }.to raise_error(RuntimeError)
  end

end
