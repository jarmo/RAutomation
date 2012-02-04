require "spec_helper"

describe "MsUia::Window", :if => SpecHelper.adapter == :ms_uia do



  it "move and click" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
                            window.maximize
    window.move_mouse(62,46)
    sleep 1
    window.click_mouse
    sleep 1

  end

=begin
  it "control by focus" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    button = window.button(:value => "Reset")
    button.set_focus
    control = window.control(:id => "button1", :focus => "")

    box2 = button.bounding_rectangle
    box1 = control.bounding_rectangle

    box1.should == box2
  end

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
    window.button(:value => "&About").set_focus
    window.button(:value => "&About").should have_focus

    window.send_keys("{tab}{tab}{tab}")
    button = window.button(:value => "Close")
    button.should exist
    button.should have_focus
  end

  it "send keystrokes to a text field" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    text_field = RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField")
    text_field.set_focus
    window.send_keys("abc123ABChiHI!\#@$%^&*()\"/-,'&_<>")
    text_field.value.should == "abc123ABChiHI!\#@$%^&*()\"/-,'&_<>"
  end

  it "sending keystrokes does not change argument string" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    text_field = RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField")
    text_field.set_focus()

    an_important_string = "Don't lose me"
    window.send_keys(an_important_string)
    an_important_string.should == "Don't lose me"
  end

  it "#control" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.control(:id => "aboutButton").should exist
  end

  it "has controls" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.controls(:class => /BUTTON/i).size.should == 12
  end

  it "window coordinates" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.maximize
    window.bounding_rectangle.should == [-4, -4, 1444, 874]
  end
=end
end
