require 'spec_helper'

describe RAutomation::TextFields do

  it "Window#text_fields returns all text fields" do
    SpecHelper::navigate_to_simple_elements

    text_fields = RAutomation::Window.new(:title => "SimpleElementsForm").text_fields
    expect(text_fields.size).to eq(2)
    expect(text_fields.find_all {|t| t.value == "Enter some text"}.size).to eq(1)
  end

  it "Window#text_fields with parameters returns all matching text fields" do
    SpecHelper::navigate_to_simple_elements

    window = RAutomation::Window.new(:title => "SimpleElementsForm")
    text_fields = window.text_fields(:index => 0)
    expect(text_fields.size).to eq(2)
    expect(text_fields.first.value).to be == "Enter some text"
  end

end
