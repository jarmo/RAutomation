require 'spec_helper'

describe "Win32::Label", :if => SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  it "#exist?" do
    expect(window.label(:value => "This is a sample text")).to exist
    expect(window.label(:value => "This label should not exist")).to_not exist
  end

  it "#label" do
     expect(window.label(:value => "This is a sample text").value).to be == "This is a sample text"
  end
end
