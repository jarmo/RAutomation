require 'spec_helper'

describe "WinFfi::Checkbox", :if => SpecHelper.adapter == :win_ffi do
  it "#checkbox" do
    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox").should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existing-window").checkbox(:value => "Something")}.
      to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set? & #set" do
    checkbox = RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox")
    checkbox.should_not be_set

    checkbox.set
    checkbox.should be_set
  end

  it "#clear" do
    checkbox = RAutomation::Window.new(:title => "MainFormWindow").checkbox(:value => "checkBox")
    checkbox.set
    checkbox.should be_set

    checkbox.clear
    checkbox.should_not be_set
  end

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:id => "checkBox").should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:id => "checkBox").should_not be_disabled

    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:id => "checkBoxDisabled").should_not be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").checkbox(:id => "checkBoxDisabled").should be_disabled
  end

end
