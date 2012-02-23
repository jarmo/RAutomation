require "spec_helper"

describe "Win32::Window", :if => SpecHelper.adapter == :win_32 do
  it "#child" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.should exist

    # buttons are windows too. so let's find the button for now
    child = window.child(:title => /About/i)
    child.should exist
    child.title.should == "&About"
  end

  it "send tab keystrokes to move focus between elements" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.button(:value => "&About").focus
    window.button(:value => "&About").should be_focused

    window.send_keys(:tab, :tab, :tab)
    button = window.button(:value => "Close")
    button.should exist
    button.should be_focused
  end

  it "#send_keys" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    text_field = window.text_field(:index => 1)
    text_field.focus
    window.send_keys "abc123ABChiHI!"
    text_field.value.should == "abc123ABChiHI!"

    window.send_keys :space, "X"
    text_field.value.should == "abc123ABChiHI! X"

    window.send_keys [:control, "a"], :backspace
    text_field.value.should be_empty
  end

  it "#control" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.control(:value => "&About").should exist
  end

  it "has controls" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.controls(:class => /button/i).size.should == 12
  end
end
