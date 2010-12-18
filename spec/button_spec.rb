require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Button do
  it "#button" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).
            button(:value => SpecHelper::DATA[:window2_button_text]).should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existing-window").button(:value => "Something")}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#value" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).
            button(:value => SpecHelper::DATA[:window2_button_text]).value.should == SpecHelper::DATA[:window2_button_text]

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).button(:value => "non-existent-button").value}.
            to raise_exception(RAutomation::UnknownButtonException)
  end

  it "#exists?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    window.button(:value => SpecHelper::DATA[:window2_button_text]).should exist
    window.button(:value => "non-existent-button").should_not exist
  end

  it "#click" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    RAutomation::Window.wait_timeout = 0.1
    expect {window.button(:value => "non-existent-button").click}.
            to raise_exception(RAutomation::UnknownButtonException)

    button = window.button(:value => SpecHelper::DATA[:window2_button_text])
    button.should exist
    button.click
    button.should_not exist
    window.should_not exist
  end
end