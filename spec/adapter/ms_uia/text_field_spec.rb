require 'spec_helper'

describe "MsUia::TextField", :if => SpecHelper.adapter == :ms_uia do
  let(:main_form) { RAutomation::Window.new(:title => "MainFormWindow") }

  it "check for text field class" do
    main_form.text_field(:id => "checkBox").should_not exist
    main_form.text_field(:id => "textField").should exist
  end

  it "enabled/disabled" do
    main_form.text_field(:id => "textField").should be_enabled
    main_form.text_field(:id => "textField").should_not be_disabled

    main_form.text_field(:id => "textBoxDisabled").should_not be_enabled
    main_form.text_field(:id => "textBoxDisabled").should be_disabled
  end

  it "cannot set a value to a disabled text field" do
    lambda { main_form.text_field(:id => "textBoxDisabled").set "abc" }.should raise_error

    lambda { main_form.text_field(:id => "textBoxDisabled").clear }.should raise_error
  end

  it "considers a document control type a text field as well" do
    # cause the .NET framework to be loaded into the process (required to make this fail)
    main_form.select_list(:id => "treeView").expand 0
    main_form.text_field(:id => "multiLineTextField").should exist
  end

  it "can set the value of a multi line text field" do
    text_field = main_form.text_field(:id => "multiLineTextField")
    text_field.set "some dater'"
    text_field.value.should eq("some dater'")
  end

end
