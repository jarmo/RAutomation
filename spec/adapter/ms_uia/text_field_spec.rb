require 'spec_helper'

describe "MsUia::TextField", if: SpecHelper.adapter == :ms_uia do
  let(:main_form) { RAutomation::Window.new(title: "MainFormWindow") }

  it "check for text field class" do
    expect(main_form.text_field(id: "checkBox").exist?).to_not be true
    expect(main_form.text_field(id: "textField").exist?).to be true
  end

  it "enabled/disabled" do
    expect(main_form.text_field(id: "textField").enabled?).to be true
    expect(main_form.text_field(id: "textField").disabled?).to_not be true

    expect(main_form.text_field(id: "textBoxDisabled").enabled?).to_not be true
    expect(main_form.text_field(id: "textBoxDisabled").disabled?).to be true
  end

  it "cannot set a value to a disabled text field" do
    expect { main_form.text_field(id: "textBoxDisabled").set "abc" }.to raise_error(RuntimeError)

    expect { main_form.text_field(id: "textBoxDisabled").clear }.to raise_error(RuntimeError)
  end

  it "considers a document control type a text field as well" do
    # cause the .NET framework to be loaded into the process (required to make this fail)
    main_form.select_list(id: "treeView").expand(0)
    expect(main_form.text_field(id: "multiLineTextField").exist?).to be true
  end

  it "can set the value of a multi line text field" do
    text_field = main_form.text_field(id: "multiLineTextField")

    # initial
    text_field.set("some dater'")
    expect(text_field.value).to eq("some dater'")

    # overwrite
    text_field.set("overwrite with this dater'")
    expect(text_field.value).to eq("overwrite with this dater'")
  end

end
