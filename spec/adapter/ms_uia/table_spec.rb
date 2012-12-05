require 'spec_helper'

describe "MsUia::Table", :if => SpecHelper.adapter == :ms_uia do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.button(:value => "Data Entry Form").click { RAutomation::Window.new(:title => "DataEntryForm").exists? }
  end

  it "#table" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")
    table.should exist
    
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            table(:class => /SysListView32/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for table class" do
    RAutomation::Window.new(:title => "DataEntryForm").table(:id => "deleteItemButton").should_not exist
    RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView").should exist
  end

  it "#strings" do
    table = RAutomation::Window.new(:title => "MainFormWindow").table(:id => "FruitListBox")

    table.strings.should == ["Apple", "Orange", "Mango"]
  end

  it "#strings with nested elements" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")

    table.strings.should == [
        ["Name", "Date of birth", "State"],
        ["John Doe", "12/15/1967", "FL"],
        ["Anna Doe", "3/4/1975", ""]
    ]
  end

  it "#select" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")

    table.select(1)
    table.should_not be_selected(2)

    table.select(2)
    table.should be_selected(2)
  end

  it "#row_count" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")
    table.row_count.should eq(2)
  end

  context "table items" do
    let(:table) { RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView") }

    it "should have all of the items" do
      table.items.count.should eq(2)
    end

    it "have a value for all of them" do
      table.items.map(&:value).should eq ["John Doe", "Anna Doe"]
    end

    it "have a row for all of them" do
      table.items.map(&:row).should eq [0, 1]
    end

    it "have cells" do
      table.items[0].cells.count.should eq 3
    end

    context "item cells" do
      let(:cells) { table.items[0].cells }

      it "have a value" do
        cells.map(&:value).should eq ["John Doe", "12/15/1967", "FL"]
      end

      it "have a location" do
        cells.map(&:location).should eq [ [0, 0], [0, 1], [0, 2] ]
      end
    end

  end

end

