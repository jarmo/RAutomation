require 'spec_helper'

describe RAutomation::Button do
  it "#button" do
    expect(RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).button(:value => "Close")).to exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existing-window").button(:value => "Something")}.
      to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#value" do
    expect(RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).
            button(:value => "Close").value).to be == "Close"

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).button(:value => "non-existent-button").value}.
      to raise_exception(RAutomation::UnknownButtonException)
  end

  it "#exists?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    expect(window.button(:value => "Close")).to exist
    expect(window.button(:value => "non-existent-button")).not_to exist
  end

  it "clicking non-existing button raises exception" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::Window.wait_timeout = 0.1
    expect {window.button(:value => "non-existent-button").click}.
      to raise_exception(RAutomation::UnknownButtonException)
  end

  it "#click" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])

    button = window.button(:value => "Close")
    expect(button).to exist
    button.click

    expect(button).not_to exist
    RAutomation::WaitHelper.wait_until { !window.exists? }
  end

  it "#click with a block for defining successful click returning false raises a TimeoutError" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::Window.wait_timeout = 5
    button = window.button(:value => "Close")
    expect {button.click {false}}.
      to raise_exception(RAutomation::WaitHelper::TimeoutError)

    expect(button).not_to exist
    expect(window).not_to exist
  end

  it "#click with a block for defining successful click returning true" do
    RAutomation::Window.wait_timeout = 10
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    button = window.button(:value => "Close")
    expect(button).to exist
    button.click {|button| !button.exists? && !window.exists?}

    expect(button).not_to exist
    expect(window).not_to exist
  end

end
