require "spec_helper"

describe "AutoIt::Window", :if => SpecHelper.adapter == :autoit do
  it "#method_missing" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    window.MouseMove(1, 1)
    position = [window.MouseGetPosX, window.MouseGetPosY]
    position.should_not == [100, 100]

    window.MouseMove(100, 100)
    position = [window.MouseGetPosX, window.MouseGetPosY]

    position.should == [100, 100]
  end
end

