require 'spec_helper'

describe "Win32::ListBox", :if => SpecHelper.adapter == :win_32 do

  it "#exists" do
    RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0).should exist
  end

  it "#count" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0)
    list_box.count.should == 3
  end

  it "lists items" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0)
    list_box.items[0].should == "Apple"
    list_box.items[1].should == "Orange"
    list_box.items[2].should == "Mango"
  end

  it "#selected?" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0)
    list_box.should_not be_selected(2)
    list_box.select(2)
    list_box.should be_selected(2)
  end

  it "#select" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0)
    list_box.select(1)
    list_box.should be_selected(1)
    list_box.select(0)
    list_box.should be_selected(0)
    list_box.select(2)
    list_box.should be_selected(2)
  end

  it "#strings" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:index => 0)
    list_box.strings.should == ["Apple", "Orange", "Mango"]
  end
end
