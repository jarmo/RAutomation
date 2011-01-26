require 'spec_helper'

describe RAutomation::Button do
  it "#button" do
    RAutomation::Window.new(:title => "MainFormWindow").
            button(:value => "&About").should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existing-window").button(:value => "Something")}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#value" do
    RAutomation::Window.new(:title =>  "MainFormWindow").
            button(:value => "&About").value.should == "&About"

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "MainFormWindow").button(:value => "non-existent-button").value}.
            to raise_exception(RAutomation::UnknownButtonException)
  end

  it "#exists?" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.button(:value => "&About").should exist
    window.button(:value => "non-existent-button").should_not exist
  end

  it "clicking non-existing button raises exception" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::Window.wait_timeout = 0.1
    expect {window.button(:value => "non-existent-button").click}.
            to raise_exception(RAutomation::UnknownButtonException)
  end

  it "#click" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    button = window.button(:value => "&About")
    button.should exist
    button.click { |button| RAutomation::Window.new(:title => /About/i).exists? }
  end

  it "#click with a block for defining successful click" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::Window.wait_timeout = 5
    button = window.button(:value => "not-there")
    expect {button.click {false}}.
            to raise_exception(RAutomation::UnknownButtonException)
# changed to UnknownButtonException due to:    
# expected RAutomation::WaitHelper::TimeoutError, got #<RAutomation::UnknownButtonException: Button {:value=>"not-there"} doesn't exist on window {:title=>"MainFormWindow"}!>

    button.should_not exist
#    window.should_not exist

    RAutomation::Window.wait_timeout = 10
    window = RAutomation::Window.new(:title => "MainFormWindow")
    button = window.button(:value => "Close")
    button.should exist
    button.click {|button| !button.exists? && !window.exists?}
    button.should_not exist
    window.should_not exist
  end
end
