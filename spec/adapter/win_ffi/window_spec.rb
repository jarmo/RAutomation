require "spec_helper"

describe "WinFfi::Window", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::WaitHelper.wait_until {window.present?}

#    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
#    RAutomation::WaitHelper.wait_until {window.present?}
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
end
