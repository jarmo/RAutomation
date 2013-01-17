require 'spec_helper'

describe RAutomation::TextField do
  let(:main_form) { RAutomation::Window.new(:title => "MainFormWindow") }
  let(:text_field) { main_form.text_field(:class => /Edit/i, :index => 2) }

  it "#text_field" do
    main_form.text_field(:class => /Edit/i, :index => 1).should exist

    RAutomation::Window.wait_timeout = 0.1
    expect { RAutomation::Window.new(:title => "non-existent-window").
        text_field(:class => "Edit") }.
        to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set" do
    text_field.set "hello!"

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(:class => "non-existing-field").set "hello!" }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#clear" do
    text_field.set "hello!"
    text_field.value.should == "hello!"
    text_field.clear
    text_field.value.should be_empty

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(:class => "non-existent-field").clear }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#value" do
    text_field.set "hello!"
    text_field.value.should == "hello!"

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(:class => "non-existent-field").value }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#exists?" do
    field  = main_form.text_field(:class => /Edit/i, :index => 1)
    field.should exist
    main_form.text_field(:class => "non-existent-field").should_not exist
  end


  it "#hwnd" do
    field  = main_form.text_field(:class => /Edit/i, :index => 1)
    field.hwnd.should be_a(Fixnum)

    RAutomation::Window.wait_timeout = 0.1
    expect { main_form.text_field(:class => "non-existing-window").hwnd }.
        to raise_exception(RAutomation::UnknownTextFieldException)
  end
end
