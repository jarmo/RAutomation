require 'spec_helper'

describe "WinFfi::Checkbox", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "checkbox exists" do
    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox").should exist
  end

  it "find whether check box is checked" do
    checkbox = RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox")
    checkbox.should_not be_checked
    checkbox.click
    checkbox.should be_checked
  end

end
