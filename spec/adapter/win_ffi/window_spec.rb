require "spec_helper"

describe "WinFfi::Window", :if => SpecHelper.adapter == :win_ffi do
  before :all do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::WaitHelper.wait_until {window.present?}

    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "#child" do
    window = RAutomation::Window.new(:title => /Internet Explorer$/i)
    window.should exist
    child = window.child(:title => SpecHelper::DATA[:window2_title])
    child.should exist
    child.title.should == SpecHelper::DATA[:window2_title]
    child.text.should include(SpecHelper::DATA[:window2_text])
  end
end
