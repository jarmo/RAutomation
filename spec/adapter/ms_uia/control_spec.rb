require "spec_helper"


describe "MsUia::Control", :if => SpecHelper.adapter == :ms_uia do

  it "control coordinates", :special => false do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.maximize
    control = window.control(:id => "radioButtonReset")
    control.bounding_rectangle.should be_all {|coord| coord.between?(200, 400)}
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

end
