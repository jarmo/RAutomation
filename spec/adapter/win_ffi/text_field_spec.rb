require 'spec_helper'

describe "WinFfi::TextField", :if => SpecHelper.adapter == :win_ffi do

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField").should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField").should_not be_disabled

    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").should_not be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textBoxDisabled").should be_disabled
  end

end
