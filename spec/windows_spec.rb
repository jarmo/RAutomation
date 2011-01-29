require 'spec_helper'

describe RAutomation::Windows do
  subject {self}

  it "Window.windows returns all windows" do
    SpecHelper::navigate_to_simple_elements

    windows = RAutomation::Window.windows
    windows.should be_a(RAutomation::Windows)
    windows.size.should be >= 2
    expected_windows = [
      RAutomation::Window.new(:title => "MainFormWindow"),
      RAutomation::Window.new(:title => "SimpleElementsForm")
    ]
    should have_all_windows(expected_windows, windows)
  end

  it "Windows#windows returns all similar windows" do
    windows = RAutomation::Window.new(:title => "MainFormWindow").windows
    windows.should be_a(RAutomation::Windows)
    windows.size.should == 1
    expected_windows = [
      RAutomation::Window.new(:title => "MainFormWindow")
    ]
    should have_all_windows(expected_windows, windows)
  end

  it "Windows#windows with parameters returns all matching windows" do
    SpecHelper::navigate_to_simple_elements

    windows = RAutomation::Window.new(:title => "MainFormWindows").windows(:title => "SimpleElementsForm")
    windows.should be_a(RAutomation::Windows)

    windows.size.should == 1
    expected_windows = [
      RAutomation::Window.new(:title => "SimpleElementsForm")
    ]
    should have_all_windows(expected_windows, windows)
  end

  def has_all_windows?(expected_windows, windows)
    expected_windows.all? do |expected_window|
      matched_windows = windows.find_all {|win| win.hwnd == expected_window.hwnd}
      matched_windows.size == 1
    end
  end

end
