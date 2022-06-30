require 'spec_helper'

describe "Win32::ListBox", :if => SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(:title => "MainFormWindow") }
  it "#exists" do
     expect(window.list_box(:index => 0)).to exist
  end

  it "#count" do
    expect(window.list_box(:index => 0).count).to eq(3)
  end

  it "lists items" do
    list_box = window.list_box(:index => 0)
    expect(list_box.items[0]).to be == "Apple"
    expect(list_box.items[1]).to be == "Orange"
    expect(list_box.items[2]).to be == "Mango"
  end

  it "#selected?" do
    list_box = window.list_box(:index => 0)
    expect(list_box.selected?(2)).to_not be true
    list_box.select(2)
    expect(list_box.selected?(2)).to be true
  end

  it "#select" do
    list_box = window.list_box(:index => 0)
    list_box.select(1)
    expect(list_box.selected?(1)).to be true
    list_box.select(0)
    expect(list_box.selected?(0)).to be true
    list_box.select(2)
    expect(list_box.selected?(2)).to be true
  end

  it "#strings" do
    list_box = window.list_box(:index => 0)
    expect(list_box.strings).to be == ["Apple", "Orange", "Mango"]
  end
end
