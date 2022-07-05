require 'spec_helper'

describe "Win32::Table", if: SpecHelper.adapter == :win_32 do
  before :each do
    window = RAutomation::Window.new(title: "MainFormWindow")
    window.button(value: "Data Entry Form").click { RAutomation::Window.new(title: "DataEntryForm").exists? }
  end

  it "#table" do
    table = RAutomation::Window.new(title: "DataEntryForm").table
    expect(table).to exist
    
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existent-window").
            table(class: /SysListView32/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#select" do
    table = RAutomation::Window.new(title: "DataEntryForm").table
    expect(table.selected?(2)).to_not be true
    table.select(2)
    expect(table.selected?(2)).to be true
  end

end

