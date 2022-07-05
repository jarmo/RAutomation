require 'spec_helper'

describe RAutomation::Windows do
  subject { self }

  before :each do
    @pid2 = IO.popen(SpecHelper::DATA[:window2]).pid
    window = RAutomation::Window.new(pid: @pid2)
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "Window.windows returns all windows" do
    windows = RAutomation::Window.windows
    expect(windows).to be_a(RAutomation::Windows)
    expect(windows.size).to be >= 2
    expected_windows = [
      RAutomation::Window.new(pid: @pid1),
      RAutomation::Window.new(pid: @pid2)
    ]
    expect(has_all_windows?(expected_windows, windows)).to be true
  end
  
  it "Window.windows accepts locators too" do
    windows = RAutomation::Window.windows(title: SpecHelper::DATA[:window1_title])
    expect(windows).to be_a(RAutomation::Windows)
    expect(windows.size) == 1
    expected_windows = [
      RAutomation::Window.new(pid: @pid1),
    ]
    expect(has_all_windows?(expected_windows, windows)).to be true
  end

  it "Windows#windows returns all similar windows" do
    windows = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).windows
    expect(windows).to be_a(RAutomation::Windows)
    expect(windows.size).to be == 1
    expected_windows = [
      RAutomation::Window.new(pid: @pid1),
    ]
    expect(has_all_windows?(expected_windows, windows)).to be true
  end

  it "Windows#windows with parameters returns all matching windows" do
    windows = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
                                 .windows(title: SpecHelper::DATA[:window2_title])
    expect(windows).to be_a(RAutomation::Windows)

    expect(windows.size).to eq(2) # this always returns 2?
    expected_windows = [
      RAutomation::Window.new(pid: @pid2),
    ]

    expect(has_all_windows?(expected_windows, windows)).to be true
  end

  it "Window.windows doesn't allow :hwnd or :pid as it's locators" do
  RAutomation::Window.wait_timeout = 0.1
  expect { RAutomation::Window.windows(hwnd: 123) }.
      to raise_exception(RAutomation::ElementCollections::UnsupportedLocatorException)

  expect { RAutomation::Window.windows(pid: 123) }.
      to raise_exception(RAutomation::ElementCollections::UnsupportedLocatorException)
  end

  after :each do
    Process.kill(9, @pid2) rescue nil    
  end

  def has_all_windows?(expected_windows, windows)
    expected_windows.all? do |expected_window|
      matched_windows = windows.find_all {|win| win.hwnd == expected_window.hwnd}
      matched_windows.size == 1
    end
  end

end
