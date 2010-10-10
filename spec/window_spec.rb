require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Window do
  it "RAutomation::Window.implementation" do
    RAutomation::Window.new(:title => "random").implementation.should == (ENV["RAUTOMATION_IMPLEMENTATION"] || RAutomation::Implementations::Helper.default_implementation)
  end

  it "Window#new by full title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should exist
  end

  it "Window#new by regexp title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).should exist
  end

  it "Window#new by hwnd" do
    hwnd = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).hwnd
    window = RAutomation::Window.new(:hwnd => hwnd)
    window.should exist
    window.title.should == SpecHelper::DATA[:window1_title]
  end

  it "#exists?" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should exist
    RAutomation::Window.new(:title => "non-existing-window").should_not exist
  end

  it "#visible?"do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should be_visible
    lambda{RAutomation::Window.new(:title => "non-existing-window").visible?}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#present?"do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).should be_present
    RAutomation::Window.new(:title => "non-existing-window").should_not be_present
  end

  it "#hwnd" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).hwnd.should be_a(Fixnum)
    lambda {RAutomation::Window.new(:title => "non-existing-window").hwnd}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#title" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).title.should == SpecHelper::DATA[:window1_title]
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
    lambda {RAutomation::Window.new(:title => "non-existing-window").text}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#minimize" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).minimize.should be_true
    lambda {RAutomation::Window.new(:title => "non-existing-window").minimize}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#maximize" do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title]).maximize.should be_true
    lambda {RAutomation::Window.new(:title => "non-existing-window").maximize}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#send_keys"do
    RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title]).send_keys(SpecHelper::DATA[:window2_send_keys])
    save_window = RAutomation::Window.new(:title => SpecHelper::DATA[:window3_title])
    RAutomation::WaitHelper.wait_until(15) {save_window.present?}

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
