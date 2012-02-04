require "spec_helper"

describe "AutoIt::Window", :if => SpecHelper.adapter == :autoit do

  it "mouse clicking" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    popup = RAutomation::Window.new(:title => "About")
    popup.exist?.should == false

    window.maximize
    window.move_mouse(60, 45)
    window.click_mouse

    sleep 0.1

    popup = RAutomation::Window.new(:title => "About")
    popup.exist?.should == true
  end

  it "mouse position" do
    window = RAutomation::Window.new(:title => "MainFormWindow")

    window.move_mouse(1, 1)
    window.mouse_position.should_not == [100, 100]

    window.move_mouse(100, 100)
    window.mouse_position.should == [100, 100]
  end

  it "mouse press/release" do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.maximize

    text_field = window.text_field(:name => "textField")
    text_field.set("start string")
    text_field.value.should == "start string"

    window.move_mouse(146, 103)
    window.press_mouse
    window.move_mouse(194, 103)
    window.release_mouse

    window.send_keys("^c")

    text_field.set("new string")
    text_field.value.should == "new string"

    window.move_mouse(146, 103)
    window.press_mouse
    window.move_mouse(194, 103)
    window.release_mouse
    window.send_keys("^v")

    text_field.value.should == "start string"
  end

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

