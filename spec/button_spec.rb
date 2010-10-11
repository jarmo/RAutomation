require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Button do
  it "#button" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).
            button(:text => SpecHelper::DATA[:window2_button_text]).should exist
    lambda {RAutomation::Window.new(:title => "non-existing-window").button(:text => "Something")}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#value" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).
            button(:text => SpecHelper::DATA[:window2_button_text]).value.should == SpecHelper::DATA[:window2_button_text]
    lambda {RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).button(:text => "non-existent-button").value}.
            should raise_exception(RAutomation::UnknownButtonException)
  end

  it "#exists?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    window.button(:text => SpecHelper::DATA[:window2_button_text]).should exist
    window.button(:text => "non-existent-button").should_not exist
  end

  it "#click" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    lambda{window.button(:text => "non-existent-button").click}.
            should raise_exception(RAutomation::UnknownButtonException)

    button = window.button(:text => SpecHelper::DATA[:window2_button_text])
    button.should exist
    button.click
    button.should_not exist
    window.should_not exist
  end
end