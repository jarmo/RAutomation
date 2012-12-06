require 'spec_helper'

describe "MsUia::Functions", :if => SpecHelper.adapter == :ms_uia do
  context "working with expandable / collapsable items" do
    let(:tree_view) { RAutomation::Window.new(:title => "MainFormWindow").select_list(:id => "treeView") }

    def options
      tree_view.options.map &:text
    end

    it "can be expanded by value" do
      options.should eq ["Parent One", "Parent Two"]
      tree_view.expand "Parent One"
      options.should eq ["Parent One", "Child 1", "Child 2", "Parent Two"]
    end

    it "can be expanded by index" do
      options.should eq ["Parent One", "Parent Two"]
      tree_view.expand 0
      tree_view.expand 2
      options.should eq ["Parent One", "Child 1", "Child 2", "Grandchild 1", "Parent Two"]
    end

    it "can be collapsed by value" do
      tree_view.expand "Parent One"
      options.should eq ["Parent One", "Child 1", "Child 2", "Parent Two"]
      tree_view.collapse "Parent One"
      options.should eq ["Parent One", "Parent Two"]
    end

    it "can be collapsed by index" do
      tree_view.expand 0
      options.should eq ["Parent One", "Child 1", "Child 2", "Parent Two"]
      tree_view.collapse 0
      options.should eq ["Parent One", "Parent Two"]
    end
  end

end
