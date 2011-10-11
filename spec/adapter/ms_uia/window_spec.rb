require "spec_helper"

describe "MsUia::Window", :if => SpecHelper.adapter == :ms_uia do

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

=begin
it "playing with points" do

    window1      = RAutomation::Window.new(:title => "KY - Agent Gateway Sales and Service")

    window1.activate
    a_control = window1.control(:point => [215,255])
    puts "exist?:"
    puts a_control.exist?
    puts "type:"
    puts a_control.get_current_control_type
    puts "value:"
    puts a_control.control_name

    puts " "

a_control = window1.control(:point => [236,272])
    puts "exist?:"
    puts a_control.exist?
    puts "type:"
    puts a_control.new_control_type_method

    puts "value:"
    puts a_control.control_name

  end



  it "control visibility" do

    window1      = RAutomation::Window.new(:title => "KY - Agent Gateway Sales and Service")

    window1.activate
    button = window1.button(:value => "Sm_Modify_N\nSm_Modify_D\nSm_Modify_P")
    puts "exist?:"
    puts button.exist?
    puts "type:"
    puts button.get_current_control_type
    puts "visible?:"
    puts button.visible?

button = window1.button(:value => "Sm_Print_Rate_Report_N\nSm_Print_Rate_Report_D\nSm_Print_Rate_Report_P")
    puts "exist?:"
    puts button.exist?
    puts "type:"
    puts button.get_current_control_type
    puts "visible?:"
    puts button.visible?
  end
=end
end
