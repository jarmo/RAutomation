require 'spec_helper'

describe RAutomation::Buttons do

  it "Window#buttons returns all buttons" do
    SpecHelper::navigate_to_simple_elements

    buttons = RAutomation::Window.new(:title => "SimpleElementsForm").buttons
    buttons.size.should == 2
    buttons.find_all {|b| b.value == 'button1'}.size.should == 1
  end

  #MsUia adapter currently infinite loops on this test
  it "Window#buttons with parameters returns all matching buttons" do
    unless SpecHelper.adapter == :ms_uia
      SpecHelper::navigate_to_simple_elements

      buttons = RAutomation::Window.new(:title => "SimpleElementsForm").buttons(:value => 'button1')
      buttons.size.should == 1
      buttons.first.value.should == 'button1'
    end
  end

end
