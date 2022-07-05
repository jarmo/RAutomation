require 'spec_helper'

describe RAutomation::TextField do
  let(:main_form) { RAutomation::Window.new(title: "MainFormWindow") }
  let(:text_field) { main_form.text_field(class: /Edit/i, index: 2) }

  it "#text_field" do
    expect(main_form.text_field(class: /Edit/i, index: 1).exist?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect { RAutomation::Window.new(title: "non-existent-window").
        text_field(class: "Edit") }.
        to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set" do
    text_field.set"hello!"

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(class: "non-existing-field").set "hello!" }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#clear" do
    text_field.set "hello!"
    expect(text_field.value).to be == "hello!"
    text_field.clear
    expect(text_field.value.empty?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(class: "non-existent-field").clear }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#value" do
    text_field.set "hello!"
    expect(text_field.value).to be == "hello!"

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(class: "non-existent-field").value }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#exists?" do
    field  = main_form.text_field(class: /Edit/i, index: 1)
    expect(field.exist?).to be true
    expect(main_form.text_field(class: "non-existent-field").exist?).to_not be true
  end

  it "#hwnd" do
    field  = main_form.text_field(class: /Edit/i, index: 1)
    expect(field.hwnd).to be_a(Integer)

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(class: "non-existing-window").hwnd }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#hwnd locator" do
    field  = main_form.text_field(class: /Edit/i, index: 1)
    expect(field.hwnd).to be_a(Integer)
    expect(main_form.text_field(hwnd: field.hwnd).exist?).to be true
  end
end
