require 'spec_helper'

describe RAutomation::TextFields do

  it "Window#text_fields returns all text fields" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    text_fields = window.text_fields
    text_fields.size.should == 1
    text_fields.find_all {|t| t.value == SpecHelper::DATA[:window2_text_field_value]}.size.should == 1
  end

  it "Window#text_fields with parameters returns all matching text fields" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    text_fields = window.text_fields(:index => 0)
    text_fields.size.should == 1
    text_fields.first.value.should == SpecHelper::DATA[:window2_text_field_value]
  end

end
