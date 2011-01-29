require 'spec_helper'

describe "WinFfi::RadioButton", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "radio button exists" do
    RAutomation::Window.new(:title => "MainFormWindow").radio(:value => "Option 1").should exist
    RAutomation::Window.new(:title => "MainFormWindow").radio(:value => "Option 2").should exist
  end

  it "alias exists? for exist?" do
    fail "Alias exists? not found" unless RAutomation::Window.new(:title => "MainFormWindow").radio(:value => "Option 1").exists? == true
  end

  it "click on radio buttons" do
    radio1 = RAutomation::Window.new(:title => "MainFormWindow").radio(:value => "Option 1")
    radio2 = RAutomation::Window.new(:title => "MainFormWindow").radio(:value => "Option 2")

    radio1.should_not be_set
    radio2.should_not be_set

    radio1.click
    radio1.should be_set

    radio2.click
    radio2.should be_set
  end

end
