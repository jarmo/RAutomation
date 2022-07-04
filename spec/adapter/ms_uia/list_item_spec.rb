require "spec_helper"

describe "MsUia::ListItem", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#exists" do
    expect(window.list_item(value: "Apple").exist?).to be true
    expect(window.list_item(value: "This is a sample text").exist?).to_not be true
  end

  it "#value" do
    expect(window.list_item(value: "Apple").value).to be == "Apple"
  end

end