require 'spec_helper'

describe "WinFfi::ListBox", :if => SpecHelper.adapter == :win_ffi do

  it "#exists" do
    RAutomation::Window.new(:title => "MainFormWindow").list_box(:id => "FruitListBox").should exist
  end

  it "check for listbox class" do
    RAutomation::Window.new(:title => "MainFormWindow").list_box(:id => "textField").should_not exist
  end

  it "counts items" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:id => "FruitListBox")
    list_box.count.should == 3
  end

  it "lists items" do
    list_box = RAutomation::Window.new(:title => "MainFormWindow").list_box(:id => "FruitListBox")
    list_box.items[0].should == "Apple"
    list_box.items[1].should == "Orange"
    list_box.items[2].should == "Mango"
  end

end
