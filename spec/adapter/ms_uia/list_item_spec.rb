require "spec_helper"

describe "MsUia::ListBox", :if => SpecHelper.adapter == :ms_uia do

  it "#exists" do
    sleep 1
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "Apple").should exist
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "This is a sample text").should_not exist
  end

  it "#value" do
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "Apple").value.should == "Apple"
  end

end