require "spec_helper"

describe "WinFfi::Window", :if => SpecHelper.adapter == :win_ffi do
  it "#child" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.should exist

    # buttons are windows too. so let's find the button for now
    child = window.child(:title => /About/i)
    child.should exist
    child.title.should == "&About"
    #    child.text.should include "About"
  end

  it "send tab keystrokes to move focus between elements" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.button(:value => "&About").should have_focus

    window.send_keystrokes("{tab}{tab}{tab}")
    button = window.button(:value => "Close")
    button.should exist
    button.should have_focus
  end

  it "#control" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.control(:id => "aboutButton").should exist
  end

  it "has controls" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.controls(:class => /BUTTON/i).size.should == 12
  end
end
