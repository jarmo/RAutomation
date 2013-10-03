require 'spec_helper'

describe "MsUia::Button", :if => SpecHelper.adapter == :ms_uia do
  it "find by id" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:id => "aboutButton").should exist
  end

  it "check for button class" do
    RAutomation::Window.new(:title => "MainFormWindow").button(:id => "textField").should_not exist
  end


  it "enabled/disabled" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:id => "enabledButton").should be_enabled
    window.button(:id => "enabledButton").should_not be_disabled

    window.button(:id => "disabledButton").should be_disabled
    window.button(:id => "disabledButton").should_not be_enabled
  end

  it "#focus" do
    button = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).button(:id => "enabledButton")
    button.should_not be_focused

    button.focus
    button.should be_focused
  end

  it "cannot click disabled button" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    expect { window.button(:id => "disabledButton").click }.to raise_error
  end

  it "cannot set focus to disabled button" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    expect { window.button(:id => "disabledButton").focus }.to raise_error
  end

end