require 'spec_helper'

describe "WinFfi::SelectList", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "#select_list" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i).should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            select_list(:class => /COMBOBOX/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#options" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)
    select_list.options.size.should == 5

    expected_options = ["Apple", "Caimito", "Coconut", "Orange", "Passion Fruit"]
    select_list.options.map {|option| option.text}.should == expected_options
  end

  it "#selected?" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)
    select_list.options(:text => "Apple")[0].should_not be_selected
    select_list.options(:text => "Apple")[0].select.should be_true
    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#value" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)

    #default empty state
    select_list.value.should == ""

    select_list.options(:text => "Apple")[0].select
    select_list.value.should == "Apple"

    select_list.options(:text => "Caimito")[0].select
    select_list.value.should == "Caimito"
  end

end
