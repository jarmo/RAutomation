require 'spec_helper'

describe 'MsUia::Table', if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  let(:data_entry) { RAutomation::Window.new(title: "DataEntryForm") }
  let(:data_grid_view) { window.button(value: 'Data Grid View').click {true}; RAutomation::Window.new(title: /DataGridView/) }
  let(:large_grid) { data_entry.close; data_grid_view.table(id: 'dataGridView1') }
  let(:table) { data_entry.table(id: "personListView") }
  let(:toggle_multi_select) { data_entry.button(value: 'Toggle Multi').click { true } }

  before :each do
    window.button(value: "Data Entry Form").click { RAutomation::Window.new(title: "DataEntryForm").exists? }
  end

  it "#table" do
    expect(table.exist?).to be true
    
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existent-window").
            table(class: /SysListView32/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for table class" do
    expect(RAutomation::Window.new(title: "DataEntryForm").table(id: "deleteItemButton").exist?).to_not be true
  end

  it "#strings" do
    table = RAutomation::Window.new(title: "MainFormWindow").table(id: "FruitListBox")

    expect(table.strings).to be == ["Apple", "Orange", "Mango"]
  end

  it "#strings with nested elements" do

    expect(table.strings).to be == [
        ["Name", "Date of birth", "State"],
        ["John Doe", "12/15/1967", "FL"],
        ["Anna Doe", "3/4/1975", ""]
    ]
  end

  it "#row_count" do
     expect(table.row_count).to eq(2)
  end

  it '#select' do
    large_grid.select(value: /^FirstName[1-9]$/)
    first_nine = large_grid.rows.take(9)
    expect(first_nine.count).to eq(9)
    first_nine.should be_all(&:selected?)
  end

  it '#clear' do
    first_three = large_grid.rows.take(3)
    next_six = large_grid.rows.take_while { |r| r.index.between?(3, 9) }
    large_grid.select(value: /^FirstName[1-9]$/)

    large_grid.clear(value: /^FirstName[1-3]$/)

    expect(first_three.all?(&:selected?)).to be false
    expect(next_six.all?(&:selected?)).to be true
  end

  it '#selected_rows' do
    large_grid.select(value: /^FirstName[1-5]$/)
    expect(large_grid.selected_rows.map(&:index)).to eq([0, 1, 2, 3, 4])
  end

  context "#rows" do
    it "has rows" do
      expect(table.rows.size).to eq(2)
    end

    it 'are quick to find' do
      expect(large_grid.row_count).to eq(51)

      start = Time.now
      expect(large_grid.row(index: 50).exists?).to be true
      expect((Time.now - start)).to be < 1.5
    end

    it "have values" do
      expect(table.rows.map(&:value)).to eq(["John Doe", "Anna Doe"])
    end

    it "values are also text" do
      expect(table.rows.map(&:text)).to eq(["John Doe", "Anna Doe"])
    end

    it "can be selected" do
      row = table.row(index: 1)
      row.select
      expect(row.selected?).to be true
    end

    it "can be cleared" do
      row = table.row(index: 1)
      row.select

      row.clear
      expect(row.selected?).to_not be true
    end

    it "can select multiple rows" do
      table.rows.each(&:select)
      expect(table.rows.all?(&:selected?)).to be true
    end

    it "plays nice if the table does not support multiple selections" do
      toggle_multi_select

      first_row = table.rows.first
      last_row = table.rows.last

      first_row.select
      last_row.select

      expect(first_row.selected?).to_not be true
      expect(last_row.selected?).to be true
    end

    context "locators" do
      it "can locate by text" do
        expect(table.rows(text: "Anna Doe").size).to eq(1)
      end

      it "can locate by regex" do
        expect(table.rows(text: /Doe/).size).to eq(2)
      end

      it "can locate by index" do
        expect(table.rows(index: 1).first.text).to eq("Anna Doe")
      end

      it "an index is also a row" do
        expect(table.rows(row: 1).first.text).to eq("Anna Doe")
      end
    end

    context "singular row" do
      it "grabs the first by default" do
        expect(table.row.text).to eq("John Doe")
      end

      it "can haz locators too" do
        expect(table.row(text: "Anna Doe").text).to eq("Anna Doe")
      end
    end

    context "Row#cells" do
      let(:row) { table.row }

      it "has cells" do
        expect(row.cells.size).to eq(3)
      end
      
      it "cells have values" do
        expect(row.cells.map(&:value)).to eq(["John Doe", "12/15/1967", "FL"])
      end

      it "values are also text" do
        expect(row.cells.map(&:text)).to eq(["John Doe", "12/15/1967", "FL"])
      end

      context "locators" do
        it "can locate by text" do
           expect(row.cells(text: "FL").size).to eq(1)
        end

        it "can locate by regex" do
          expect(row.cells(text: /[JF]/).size).to eq(2)
        end

        it "can locate by index" do
          expect(row.cells(index: 1).first.text).to eq("12/15/1967")
        end

        it "an index is also a column" do
          expect(row.cells(column: 1).first.text).to eq("12/15/1967")
        end
      end

      context "singular cell" do
        it "grabs the first by default" do
          expect(row.cell.text).to eq("John Doe")
        end

        it "can haz locators too" do
          expect(row.cell(text: "FL").text).to eq("FL")
        end
      end
    end
  end

end

