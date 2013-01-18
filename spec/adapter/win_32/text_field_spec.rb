require 'spec_helper'

describe "Win32::TextField", :if => SpecHelper.adapter == :win_32 do

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:index => 2).should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:index => 2).should_not be_disabled
  end

  it "cannot set a value to a disabled text field" do
    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field(:index => 1).set "abc" }.should raise_error
    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field(:index => 1).clear }.should raise_error
  end

  it "#send_keys" do
    text_field = RAutomation::Window.new(:title => "MainFormWindow").text_field(:index => 2)
    text_field.send_keys "abc"
    text_field.value.should == "abc"

    text_field.send_keys [:control, "a"], :backspace
    text_field.value.should be_empty
  end

end
