require 'spec_helper'

describe "MsUia::TextField", :if => SpecHelper.adapter == :ms_uia do

  it "check for text field class" do
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "checkBox").should_not exist
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField").should exist
  end

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField").should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField").should_not be_disabled

    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").should_not be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").should be_disabled
  end

  it "cannot set a value to a disabled text field" do
    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").set "abc" }.should raise_error

    lambda { RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").clear }.should raise_error
  end

  it "considers a document control type a text field as well", :focus => true do
    # cause the .NET framework to be loaded into the process (required to make this fail)
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "treeView").expand 0

    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "multiLineTextField").should exist
  end

end
