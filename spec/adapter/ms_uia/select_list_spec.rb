require 'spec_helper'

describe "MsUia::SelectList", :if => SpecHelper.adapter == :ms_uia do
  it "#select_list" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox").should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            select_list(:class => /COMBOBOX/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for select list class" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "textField").should_not exist
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox").should exist
  end

  it "#options" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")
    select_list.options.size.should == 5

    expected_options = ["Apple", "Caimito", "Coconut", "Orange", "Passion Fruit"]
    select_list.options.map {|option| option.text}.should == expected_options
  end

  it "#selected? & #select" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")
    select_list.options(:text => "Apple")[0].should_not be_selected
    select_list.options(:text => "Apple")[0].select.should be_true
    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#set" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")
    select_list.options(:text => "Apple")[0].should_not be_selected
    select_list.set("Apple")
    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#value" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")

    #default empty state
    select_list.value.should == ""

    select_list.options(:text => "Apple")[0].select
    select_list.value.should == "Apple"

    select_list.options(:text => "Caimito")[0].select
    select_list.value.should == "Caimito"
  end

  it "enabled/disabled" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox").should be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox").should_not be_disabled

    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "comboBoxDisabled").should_not be_enabled
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "comboBoxDisabled").should be_disabled
  end

  it "#option" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")

    select_list.option(:text => "Apple").should_not be_selected
    select_list.option(:text => "Apple").set
    select_list.option(:text => "Apple").should be_selected
  end

  it "cannot select anything on a disabled select list" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "comboBoxDisabled")

    lambda { select_list.option(:text => "Apple").set }.should raise_error
  end

  it "fires change event when the value is set" do

    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")

    select_list.option(:text => "Apple").should_not be_selected
    select_list.set("Apple")
    select_list.option(:text => "Apple").should be_selected

    label = RAutomation::Window.new(:title => "MainFormWindow").label(:id => "fruitsLabel")
    RAutomation::WaitHelper.wait_until { label.exist? }
    label.value.should == "Apple"
  end

  it "fires change event when the index changes" do

    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "FruitsComboBox")
    label = RAutomation::Window.new(:title => "MainFormWindow").label(:id => "fruitsLabel")

    select_list.options[4].select
    select_list.option(:text => "Passion Fruit").should be_selected
    label.value.should == "Passion Fruit"

    select_list.select 3
    select_list.option(:text => "Orange").should be_selected
    label.value.should == "Orange"
  end
end
