require 'spec_helper'

describe "WinFfi::Label", :if => SpecHelper.adapter == :win_ffi do
  it "#exist?" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    window.label(:value => "This is a sample text").should exist
    window.label(:value => "This label should not exist").should_not exist
  end

end
