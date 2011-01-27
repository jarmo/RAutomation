require 'spec_helper'

describe "WinFfi::Table", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::WaitHelper.wait_until {window.present?}
    window.button(:value => "Data Entry Form").click { RAutomation::Window.new(:title => "DataEntryForm").exists? }
  end

  it "finds the table" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:class => /SysListView32/i)
    table.should exist
  end

  it "counts the number of rows" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:class => /SysListView32/i)
    table.row_count.should == 2
  end

end
