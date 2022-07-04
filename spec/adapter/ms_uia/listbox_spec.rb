require 'spec_helper'

describe "MsUia::ListBox", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  let(:label) { window.label(id: "fruitsLabel") }
  let(:list_box) { window.list_box(id: "FruitListBox") }

  it "#exists" do
    expect(list_box.exist?).to be true
  end

  it "checks for ListBox class" do
    expect(window.list_box(id: "textField").exist?).to_not be true
    expect(list_box.exist?).to be true
  end

  it "counts items" do
    expect(list_box.count).to be == 3
  end

  it "lists items" do
    expect(list_box.items[0].value).to be == "Apple"
    expect(list_box.items[1].value).to be == "Orange"
    expect(list_box.items[2].value).to be == "Mango"
  end

  it "returns a value" do
    expect(list_box.value).to be == ""
    list_box.select(0)
    expect(list_box.value).to be == "Apple"
    list_box.select(1)
    expect(list_box.value).to be == "Orange"
    list_box.select(2)
    expect(list_box.value).to be == "Mango"
  end

  it "#selected?" do
    expect(list_box.selected?(2)).to be false
    list_box.select(2)
    expect(list_box.selected?(2)).to be true
  end

  it "#select" do
    list_box.select(1)
    expect(list_box.selected?(1)).to be true

    list_box.select(0)
    expect(list_box.selected?(0)).to be true

    list_box.select(2)
    expect(list_box.selected?(2)).to be true
  end

  it "#strings" do
    expect(list_box.strings).to be == ["Apple", "Orange", "Mango"]
  end

  it "fires events when the index changes" do
    ['Apple', 'Orange', 'Mango'].each_with_index do |value, index|
      list_box.select(index)
      expect(label.value).to eq(value)
    end
  end

  it 'fires events even when the item is not in the current view' do
    window.menu(text: 'File').menu(text: 'Add Some Fruits').open

    list_box.strings.each_with_index do |value, index|
      list_box.select(index)
      expect(label.value).to eq(value)
    end
  end
end
