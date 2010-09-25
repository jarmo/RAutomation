require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RAutomation::Button do
  it "#button" do
    RAutomation::Window.new(/file download/i).button("&Save").should exist
    lambda {RAutomation::Window.new("non-existing-window").button("&Save")}.
            should raise_exception(RAutomation::UnknownWindowException)
  end

  it "#value" do
    RAutomation::Window.new(/file download/i).button("&Save").value.should == "&Save"
    lambda {RAutomation::Window.new(/file download/i).button("non-existent-button").value}.
            should raise_exception(RAutomation::UnknownButtonException)
  end

  it "#exists?" do
    RAutomation::Window.new(/file download/i).button("Cancel").should exist
    RAutomation::Window.new(/file download/i).button("non-existent-button").should_not exist
  end

  it "#click" do
    button = RAutomation::Window.new(/file download/i).button("&Save")
    button.should exist
    button.click
    button.should_not exist

    window = RAutomation::Window.new("Save As")
    RAutomation::WaitHelper.wait_until(10) {window.present?}

    lambda{window.button("non-existent-button").click}.
            should raise_exception(RAutomation::UnknownButtonException)
  end
end