require 'spec_helper'

describe "MsUia::Label", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#exist?" do
    expect(window.label(value: "This is a sample text").exist?).to be true
    expect(window.label(value: "This label should not exist").exist?).to_not be true
  end

  it "check for label class" do
    expect(window.label(id: "textField").exist?).to_not be true
    expect(window.label(id: "label1").exists?).to be true
  end

  it "#label" do
    expect(window.label(value: "This is a sample text").value).to be == "This is a sample text"
  end
end
