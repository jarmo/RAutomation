require 'spec_helper'

describe "WinFfi::Button", :if => SpecHelper.adapter == :win_ffi do
  it "find by id" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:id => "aboutButton").should exist
  end

  it "enabled/disabled" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:id => "enabledButton").should be_enabled
    window.button(:id => "enabledButton").should_not be_disabled

    window.button(:id => "disabledButton").should be_disabled
    window.button(:id => "disabledButton").should_not be_enabled

  end

end