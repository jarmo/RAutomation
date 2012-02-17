require 'spec_helper'

describe "Win32::Label", :if => SpecHelper.adapter == :win_32 do
  it "#exist?" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    window.label(:value => "This is a sample text").should exist
    window.label(:value => "This label should not exist").should_not exist
  end

  it "#label" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.label(:value => "This is a sample text").value.should == "This is a sample text"
  end
end
