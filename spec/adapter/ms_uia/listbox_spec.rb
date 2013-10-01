require 'spec_helper'

describe "MsUia::ListBox", :if => SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  let(:label) { window.label(:id => "fruitsLabel") }
  let(:list_box) { window.list_box(:id => "FruitListBox") }

  it "#exists" do
    list_box.should exist
  end

  it "checks for ListBox class" do
    window.list_box(:id => "textField").should_not exist
    list_box.should exist
  end

  it "counts items" do
    list_box.count.should == 3
  end

  it "lists items" do
    list_box.items[0].value.should == "Apple"
    list_box.items[1].value.should == "Orange"
    list_box.items[2].value.should == "Mango"
  end

  it "returns a value" do
    list_box.value.should == ""
    list_box.select(0)
    list_box.value.should == "Apple"
    list_box.select(1)
    list_box.value.should == "Orange"
    list_box.select(2)
    list_box.value.should == "Mango"
  end

  it "#selected?" do
    list_box.selected?(2).should == false
    list_box.select(2)
    list_box.selected?(2).should == true
  end

  it "#select" do
    list_box.select(1)
    list_box.selected?(1).should == true

    list_box.select(0)
    list_box.selected?(0).should == true

    list_box.select(2)
    list_box.selected?(2).should == true
  end

  it "#strings" do
    list_box.strings.should == ["Apple", "Orange", "Mango"]
  end

  it "fires events when the index changes" do
    ['Apple', 'Orange', 'Mango'].each_with_index do |value, index|
      list_box.select index
      label.value.should eq(value)
    end
  end

  it 'fires events even when the item is not in the current view' do
    window.menu(text: 'File').menu(text: 'Add Some Fruits').open

    list_box.strings.each_with_index do |value, index|
      list_box.select index
      label.value.should eq(value)
    end
  end
end
