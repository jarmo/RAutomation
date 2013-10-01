require 'spec_helper'

describe "MsUia::Table", :if => SpecHelper.adapter == :ms_uia do
  let(:data_entry) { RAutomation::Window.new(:title => "DataEntryForm") }
  let(:table) { data_entry.table(:id => "personListView") }
  let(:toggle_multi_select) { data_entry.button(:value => 'Toggle Multi').click { true } }

  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.button(:value => "Data Entry Form").click { RAutomation::Window.new(:title => "DataEntryForm").exists? }
  end

  it "#table" do
    table.should exist
    
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            table(:class => /SysListView32/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for table class" do
    RAutomation::Window.new(:title => "DataEntryForm").table(:id => "deleteItemButton").should_not exist
  end

  it "#strings" do
    table = RAutomation::Window.new(:title => "MainFormWindow").table(:id => "FruitListBox")

    table.strings.should == ["Apple", "Orange", "Mango"]
  end

  it "#strings with nested elements" do

    table.strings.should == [
        ["Name", "Date of birth", "State"],
        ["John Doe", "12/15/1967", "FL"],
        ["Anna Doe", "3/4/1975", ""]
    ]
  end

  it "#row_count" do
    table.row_count.should eq(2)
  end

  context "#rows" do
    it "has rows" do
      table.rows.size.should eq 2
    end

    it "have values" do
      table.rows.map(&:value).should eq ["John Doe", "Anna Doe"]
    end

    it "values are also text" do
      table.rows.map(&:text).should eq ["John Doe", "Anna Doe"]
    end

    it "can be selected" do
      row = table.row(:index => 1)
      row.select
      row.should be_selected
    end

    it "can be cleared" do
      row = table.row(:index => 1)
      row.select

      row.clear
      row.should_not be_selected
    end

    it "can select multiple rows" do
      table.rows.each(&:select)
      table.rows.all?(&:selected?).should be_true
    end

    it "plays nice if the table does not support multiple selections" do
      toggle_multi_select

      first_row = table.rows.first
      last_row = table.rows.last

      first_row.select
      last_row.select

      first_row.should_not be_selected
      last_row.should be_selected
    end

    context "locators" do
      it "can locate by text" do
        table.rows(:text => "Anna Doe").size.should eq 1
      end

      it "can locate by regex" do
        table.rows(:text => /Doe/).size.should eq 2
      end

      it "can locate by index" do
        table.rows(:index => 1).first.text.should eq "Anna Doe"
      end

      it "an index is also a row" do
        table.rows(:row => 1).first.text.should eq "Anna Doe"
      end
    end

    context "singular row" do
      it "grabs the first by default" do
        table.row.text.should eq "John Doe"
      end

      it "can haz locators too" do
        table.row(:text => "Anna Doe").text.should eq "Anna Doe"
      end
    end

    context "Row#cells" do
      let(:row) { table.row }

      it "has cells" do
        row.cells.size.should eq 3
      end
      
      it "cells have values" do
        row.cells.map(&:value).should eq ["John Doe", "12/15/1967", "FL"]
      end

      it "values are also text" do
        row.cells.map(&:text).should eq ["John Doe", "12/15/1967", "FL"]
      end

      context "locators" do
        it "can locate by text" do
          row.cells(:text => "FL").size.should eq 1
        end

        it "can locate by regex" do
          row.cells(:text => /[JF]/).size.should eq 2
        end

        it "can locate by index" do
          row.cells(:index => 1).first.text.should eq "12/15/1967"
        end

        it "an index is also a column" do
          row.cells(:column => 1).first.text.should eq "12/15/1967"
        end
      end

      context "singular cell" do
        it "grabs the first by default" do
          row.cell.text.should eq "John Doe"
        end

        it "can haz locators too" do
          row.cell(:text => "FL").text.should eq "FL"
        end
      end
    end
  end

end

