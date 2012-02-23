require 'spec_helper'

describe "Win32::Button", :if => SpecHelper.adapter == :win_32 do
  it "enabled/disabled" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:value => "Enabled").should be_enabled
    window.button(:value => "Enabled").should_not be_disabled

    window.button(:value => "Disabled").should be_disabled
    window.button(:value => "Disabled").should_not be_enabled
  end

  it "#focus" do
    button = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).button(:value => "Enabled")
    button.should_not be_focused
    button.focus
    button.should be_focused
  end

  it "cannot click disabled button" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    lambda { window.button(:value => "Disabled").click }.should raise_error
  end

  it "cannot set focus to disabled button" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    lambda { window.button(:value => "Disabled").focus }.should raise_error
  end

end
