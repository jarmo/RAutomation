require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Window do
  before :all do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::WaitHelper.wait_until {window.present?}

    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "RAutomation::Window.implementation" do
    RAutomation::Window.new(:title => "random").implementation.should == (ENV["RAUTOMATION_IMPLEMENTATION"] || RAutomation::Implementations::Helper.default_implementation)
  end

  it "Window#new by full title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).should exist
  end

  it "Window#new by regexp title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should exist
  end

  it "Window#new by hwnd" do
    hwnd = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).hwnd
    window = RAutomation::Window.new(:hwnd => hwnd)
    window.should exist
    window.title.should == SpecHelper::DATA[:window2_title]
  end

  it "#exists?" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should exist
    RAutomation::Window.new(:title => "non-existing-window").should_not exist
  end

  it "#visible?"do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should be_visible
    RAutomation::Window.wait_timeout = 0.1
    lambda{RAutomation::Window.new(:title => "non-existing-window").visible?}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#present?"do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should be_present
    RAutomation::Window.new(:title => "non-existing-window").should_not be_present
  end

  it "#hwnd" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).hwnd.should be_a(Fixnum)
    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").hwnd}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).title.should == SpecHelper::DATA[:window2_title]
    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").title}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#activate & #active?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.activate
    window.should be_active
    non_existing_window = RAutomation::Window.new(:title => "non-existing-window")
    non_existing_window.activate
    non_existing_window.should_not be_active
  end

  it "#text" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).text.should include(SpecHelper::DATA[:window2_text])
    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").text}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#maximize" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).maximize
    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").maximize}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#minimize && #minimized?" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.should_not be_minimized
    window.minimize
    window.should be_minimized

    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").minimize}.
            should raise_exception(RAutomation::UnknownWindowException)
    lambda {RAutomation::Window.new(:title => "non-existing-window").minimized?}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#restore" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).restore
    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").restore}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#send_keys"do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    window.minimize # #send_keys should work even if window is minimized
    window.send_keys(SpecHelper::DATA[:window2_send_keys])
    RAutomation::WaitHelper.wait_until(15) {not window.exists?}

    RAutomation::Window.wait_timeout = 0.1
    lambda {RAutomation::Window.new(:title => "non-existing-window").send_keys("123")}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#close" do
    window = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    window.should exist
    window.close
    window.should_not exist

    lambda {RAutomation::Window.new(:title => "non-existing-window").close}.
            should_not raise_exception
  end
end
