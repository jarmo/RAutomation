require "spec_helper"

describe "WinFfi::Window", :if => SpecHelper.adapter == :win_ffi do
  it "#child" do
    window = RAutomation::Window.new(:title => /Internet Explorer$/i)
    window.should exist
    child = window.child(:title => SpecHelper::DATA[:window2_title])
    child.should exist
    child.title.should == SpecHelper::DATA[:window2_title]
    child.text.should include(SpecHelper::DATA[:window2_text])
  end
end
