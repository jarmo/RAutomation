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
    checkbox.should_not be_set
    checkbox.click
    checkbox.should be_checked
    checkbox.should be_set
  end

  it "clear the state" do
    checkbox = RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox")
    checkbox.should_not be_set
    checkbox.click
    checkbox.should be_set

    checkbox.clear
    checkbox.should_not be_set
  end

  it "set checked state" do
    checkbox = RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox")
    checkbox.should_not be_set

    checkbox.set true
    checkbox.should be_set

    checkbox.set false
    checkbox.should_not be_set
  end

end
