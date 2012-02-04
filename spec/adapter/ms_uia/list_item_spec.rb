require "spec_helper"

describe "MsUia::ListItem", :if => SpecHelper.adapter == :ms_uia do

  it "#exists" do
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "Apple").should exist
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "This is a sample text").should_not exist
  end

  it "#value" do
    RAutomation::Window.new(:title => "MainFormWindow").list_item(:value => "Apple").value.should == "Apple"
  end

end