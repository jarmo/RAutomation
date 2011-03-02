require 'spec_helper'

describe "RAutomation::Adapter::UIAutomation::Window" do

  it "#exists" do
    window = RAutomation::Window.new(:automationId => /MainFormWindow/)
    window.should exist
  end

end
