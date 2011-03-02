require 'spec_helper'

describe "WinFfi::Button", :if => SpecHelper.adapter == :win_ffi do
  it "find by id" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.button(:id => "aboutButton").should exist
  end
end