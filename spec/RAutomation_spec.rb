require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Window do
  before :all do
    @ie = IO.popen('"c:\\program files\\internet explorer\\iexplore.exe" http://dl.dropbox.com/u/2731643/RAutomation/test.html').pid
    sleep 5
  end

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
    RAutomation::Window.new(/rautomation testing page/i).activate.should == true
    lambda {RAutomation::Window.new("non-existing-window").activate}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#text" do
    RAutomation::Window.new(/file download/i).text.should include("Do you want to open or save this file?")
    lambda {RAutomation::Window.new("non-existing-window").text}.
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

  after :all do
    Process.kill(9, @ie) rescue nil
  end
end
