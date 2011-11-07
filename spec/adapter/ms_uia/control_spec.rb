require "spec_helper"


describe "MsUia::Control", :if => SpecHelper.adapter == :ms_uia do

  it "control coordinates", :special => false do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.maximize
    control = window.control(:id => "radioButtonReset")
    control.bounding_rectangle.should == [285, 218, 360, 241]
  end

   it "control process id", :special => true do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    control = window.control(:id => "radioButtonReset")
    control.new_pid.should == @pid1
   end

  it "has a class" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    control = window.control(:id => "radioButtonReset")
    control.control_class.should =~ /WindowsForms10.BUTTON.app.0.2bf8098_r1[0-9]_ad1/
  end

=begin
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
