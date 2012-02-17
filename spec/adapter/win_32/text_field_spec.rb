require 'spec_helper'

describe "Win32::TextField", :if => SpecHelper.adapter == :win_32 do

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").text_field.should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field.should_not be_disabled
  end

  it "cannot set a value to a disabled text field" do
    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field.set "abc" }.should raise_error
    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field.clear }.should raise_error
  end

end
