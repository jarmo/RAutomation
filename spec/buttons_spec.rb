require 'spec_helper'

describe RAutomation::Buttons do

  it "Window#buttons returns all buttons" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    buttons = window.buttons
    buttons.size.should == 2
    buttons.find_all {|b| b.value == SpecHelper::DATA[:window2_button_text]}.size.should == 1
  end

  it "Window#buttons with parameters returns all matching buttons" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    buttons = window.buttons(:value => SpecHelper::DATA[:window2_button_text])
    buttons.size.should == 1
    buttons.first.value.should == SpecHelper::DATA[:window2_button_text]
  end

end
