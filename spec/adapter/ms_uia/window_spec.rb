require "spec_helper"

describe "MsUia::Window", :if => SpecHelper.adapter == :ms_uia do


  it "window coordinates" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.maximize
    window.get_bounding_rectangle.should == [-4, -4, 1444, 874]
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

  it "control by focus" do
    window      = RAutomation::Window.new(:title => /MainFormWindow/i)

    button = window.button(:value => "Reset")
    button.set_focus

    another_button = window.get_focused_element
    box1 = another_button.bounding_rectangle
        box2 =   button.bounding_rectangle


    puts "#{box1}"
    puts "#{box2}"

    sleep 10
    box1.should == box2
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
