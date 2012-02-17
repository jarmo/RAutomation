require 'spec_helper'

describe "Win32::SelectList", :if => SpecHelper.adapter == :win_32 do
  it "#select_list" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1).should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            select_list(:class => /combobox/i, :index => 1)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#options" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1)
    select_list.options.size.should == 5

    expected_options = ["Apple", "Caimito", "Coconut", "Orange", "Passion Fruit"]
    select_list.options.map {|option| option.text}.should == expected_options
  end

  it "#selected? & #select" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1)
    select_list.options(:text => "Apple")[0].should_not be_selected
    select_list.options(:text => "Apple")[0].select.should be_true
    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#set" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1)
    select_list.options(:text => "Apple")[0].should_not be_selected
    select_list.set("Apple")
    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#value" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1)

    #default empty state
    select_list.value.should == ""

    select_list.options(:text => "Apple")[0].select
    select_list.value.should == "Apple"

    select_list.options(:text => "Caimito")[0].select
    select_list.value.should == "Caimito"
  end

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1).should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1).should_not be_disabled
  end

  it "#option" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /combobox/i, :index => 1)

    select_list.option(:text => "Apple").should_not be_selected
    select_list.option(:text => "Apple").set
    select_list.option(:text => "Apple").should be_selected
  end

  it "cannot select anything on a disabled select list" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "comboBoxDisabled")

    lambda { select_list.option(:text => "Apple").set }.should raise_error
  end
end
