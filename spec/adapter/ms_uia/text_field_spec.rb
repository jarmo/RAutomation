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
    expect { main_form.text_field(:id => "textBoxDisabled").set "abc" }.to raise_error

    expect { main_form.text_field(:id => "textBoxDisabled").clear }.to raise_error
  end

  it "considers a document control type a text field as well" do
    # cause the .NET framework to be loaded into the process (required to make this fail)
    main_form.select_list(:id => "treeView").expand 0
    main_form.text_field(:id => "multiLineTextField").should exist
  end

  it "can set the value of a multi line text field" do
    text_field = main_form.text_field(:id => "multiLineTextField")

    # initial
    text_field.set "some dater'"
    text_field.value.should eq("some dater'")

    # overwrite
    text_field.set "overwrite with this dater'"
    text_field.value.should eq("overwrite with this dater'")
  end

end
