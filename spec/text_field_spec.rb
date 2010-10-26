require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::TextField do
  it "#text_field" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).
            text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name]).should exist

    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existent-window").
            text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name])}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    window.text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name]).set "hello!"

    RAutomation::Window.wait_timeout = 0.1
    lambda {window.text_field(:class_name => "non-existing-field").set "hello!"}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#clear"do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    field = window.text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name])
    field.set "hello!"
    field.value.should == "hello!"
    field.clear
    field.value.should be_empty

    RAutomation::Window.wait_timeout = 0.1
    lambda {window.text_field(:class_name => "non-existent-field").clear}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#value" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    field = window.text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name])
    field.set "hello!"
    field.value.should == "hello!"

    RAutomation::Window.wait_timeout = 0.1
    lambda {window.text_field(:class_name => "non-existent-field").value}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#exists?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    field = window.text_field(:class_name => SpecHelper::DATA[:window2_text_field_class_name])
    field.should exist
    window.text_field(:class_name => "non-existent-field").should_not exist
  end
end