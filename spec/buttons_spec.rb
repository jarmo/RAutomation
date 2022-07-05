require 'spec_helper'

describe RAutomation::Buttons do

  it "Window#buttons returns all buttons" do
    SpecHelper::navigate_to_simple_elements

    buttons = RAutomation::Window.new(title: "SimpleElementsForm").buttons
    expect(buttons.size).to eq(2)
    expect(buttons.find_all {|b| b.value == 'button1'}.size).to eq(1)
  end

  it "Window#buttons with parameters returns all matching buttons" do
      SpecHelper::navigate_to_simple_elements

      buttons = RAutomation::Window.new(title: "SimpleElementsForm").buttons(value: 'button1')
      expect(buttons.size).to eq(1)
      expect(buttons.first.value).to eq('button1')
  end

end
