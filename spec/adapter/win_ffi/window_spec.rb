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

    window.send_keystrokes("{tab}{tab}{tab}")
  end
end
