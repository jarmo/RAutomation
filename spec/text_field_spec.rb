require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::TextField do
  before :all do
    @ie = IO.popen('"c:\\program files\\internet explorer\\iexplore.exe" http://dl.dropbox.com/u/2731643/RAutomation/test.html').pid
    RAutomation::WaitHelper.wait_until(10) {RAutomation::Window.new(/file download/i).present?}
  end

  before :all do
    RAutomation::Window.new(/file download/i).button("&Save").click
    window = RAutomation::Window.new("Save As")
    RAutomation::WaitHelper.wait_until(10) {window.present?}
  end

  it "#text_field" do
    RAutomation::Window.new("Save As").text_field("Edit1").should exist
    lambda {RAutomation::Window.new("non-existent-window").text_field("Edit1")}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#set" do
    RAutomation::Window.new("Save As").text_field("Edit1").set "hello!"
    lambda {RAutomation::Window.new("Save As").text_field("non-existing-field").set "hello!"}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#clear" do
    field = RAutomation::Window.new("Save As").text_field("Edit1")
    field.set "hello!"
    field.value.should == "hello!"
    field.clear
    field.value.should be_empty

    lambda {RAutomation::Window.new("Save As").text_field("non-existent-field").clear}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#value" do
    field = RAutomation::Window.new("Save As").text_field("Edit1")
    field.set "hello!"
    field.value.should == "hello!"

    lambda {RAutomation::Window.new("Save As").text_field("non-existent-field").value}.
            should raise_exception(RAutomation::UnknownTextFieldException)
  end

  it "#exists?" do
    RAutomation::Window.new("Save As").text_field("Edit1").should exist
    RAutomation::Window.new("Save As").text_field("non-existent-field").should_not exist
  end

  after :all do
    Process.kill(9, @ie) rescue nil
  end
end