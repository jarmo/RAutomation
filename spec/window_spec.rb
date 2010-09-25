require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Window do
  it "Window.implementation" do
    RAutomation::Window.implementation.should == RAutomation::AutoIt::Window
  end

  it "Window#new by full title" do
    RAutomation::Window.new("RAutomation testing page - Windows Internet Explorer").should exist
  end

  it "Window#new by regexp title" do
    RAutomation::Window.new(/rautomation testing page/i).should exist
  end

  it "Window#new by hwnd" do
    hwnd = RAutomation::Window.new(/rautomation testing page/i).hwnd
    RAutomation::Window.new(hwnd).should exist
    RAutomation::Window.new(hwnd).title.should == "RAutomation testing page - Windows Internet Explorer"
  end

  it "#exists?" do
    RAutomation::Window.new(/rautomation testing page/i).should exist
    RAutomation::Window.new("non-existing-window").should_not exist
  end

  it "#visible?" do
    RAutomation::Window.new(/rautomation testing page/i).should be_visible
    lambda{RAutomation::Window.new("non-existing-window").visible?}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#present?" do
    RAutomation::Window.new(/rautomation testing page/i).should be_present
    RAutomation::Window.new("non-existing-window").should_not be_present
  end

  it "#hwnd" do
    RAutomation::Window.new(/rautomation testing page/i).hwnd.should be_a(Fixnum)
    lambda {RAutomation::Window.new("non-existing-window").hwnd}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#title" do
    RAutomation::Window.new(/rautomation testing page/i).title.should == "RAutomation testing page - Windows Internet Explorer"
    lambda {RAutomation::Window.new("non-existing-window").title}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#activate" do
    RAutomation::Window.new(/rautomation testing page/i).activate.should be_true
    RAutomation::Window.new("non-existing-window").activate.should be_false
  end

  it "#text" do
    RAutomation::Window.new(/file download/i).text.should include("Do you want to open or save this file?")
    lambda {RAutomation::Window.new("non-existing-window").text}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#maximize" do
    RAutomation::Window.new(/rautomation testing page/i).maximize.should be_true
    lambda {RAutomation::Window.new("non-existing-window").maximize}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#minimize" do
    RAutomation::Window.new(/rautomation testing page/i).minimize.should be_true
    lambda {RAutomation::Window.new("non-existing-window").minimize}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#close" do
    window = RAutomation::Window.new(/rautomation testing page/i)
    window.should exist
    window.close
    window.should_not exist

    lambda {RAutomation::Window.new("non-existing-window").close}.
            should_not raise_exception
  end
end
