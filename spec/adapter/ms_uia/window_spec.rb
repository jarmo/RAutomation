require "spec_helper"

describe "MsUia::Window", :if => SpecHelper.adapter == :ms_uia do
  let(:window) {RAutomation::Window.new(:title => /MainFormWindow/i)}



  it "move and click" do
    #window = RAutomation::Window.new(:title => /MainFormWindow/i)
                            window.maximize
    window.move_mouse(62,46)
    sleep 1
    window.click_mouse
    sleep 1

  end

  context "#send_keys" do
    it "send tab keystrokes to move focus between elements" do
      window.button(:value => "&About").focus
      window.button(:value => "&About").should be_focused

      window.send_keys(:tab, :tab, :tab)
      button = window.button(:value => "Close")
      button.should exist
      button.should be_focused
    end

    it "send arbitrary characters and control keys" do
      text_field = window.text_field(:index => 1)
      text_field.focus
      window.send_keys "abc123ABChiHI!"
      text_field.value.should == "abc123ABChiHI!"

      window.send_keys :space, "X"
      text_field.value.should == "abc123ABChiHI! X"

      window.send_keys [:control, "a"], :backspace
      text_field.value.should be_empty
    end
  end

  context "#control", :focus => true do
    it "by name" do
      window.control(:name => "checkBox").should exist
    end
  end

  context "menu items" do
    let(:about_box) { RAutomation::Window.new :title => "About" }

    it "can select menu items" do
      window.menu(:text => "File").menu(:text => "About").open
      RAutomation::WaitHelper.wait_until { about_box.present? }
    end

    it "can select deep menu items" do
      window.menu(:text => "File")
            .menu(:text => "Roundabout Way")
            .menu(:text => "About").open
      RAutomation::WaitHelper.wait_until { about_box.present? }
    end

    it "raises when errors occur" do
      lambda { window.menu(:text => "File").menu(:text => "Does Not Exist").open}.should raise_error
    end

    it "indicates if the menu item does not exist" do
      begin
        window.menu(:text => "File").menu(:text => "Should Not Exist").open
        fail "Should have failed to find the menu item"
      rescue Exception => e
        e.message.should match /MenuItem with the text "Should Not Exist" does not exist/
      end
    end

    it "knows when menu items exist" do
      window.menu(:text => "File").menu(:text => "About").should exist
    end

    it "knows when menu items do not exist" do
      window.menu(:text => "File").menu(:text => "Missing").should_not exist
    end
  end

=begin
  it "control by focus" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    button = window.button(:value => "Reset")
    button.set_focus
    control = window.control(:id => "button1", :focus => "")

    box2 = button.bounding_rectangle
    box1 = control.bounding_rectangle

    box1.should == box2
  end

  it "send tab keystrokes to move focus between elements" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.button(:value => "&About").set_focus
    window.button(:value => "&About").should have_focus

    window.send_keys("{tab}{tab}{tab}")
    button = window.button(:value => "Close")
    button.should exist
    button.should have_focus
  end

  it "send keystrokes to a text field" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    text_field = RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField")
    text_field.set_focus
    window.send_keys("abc123ABChiHI!\#@$%^&*()\"/-,'&_<>")
    text_field.value.should == "abc123ABChiHI!\#@$%^&*()\"/-,'&_<>"
  end

  it "sending keystrokes does not change argument string" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    text_field = RAutomation::Window.new(:title => "MainFormWindow").text_field(:id => "textField")
    text_field.set_focus()

    an_important_string = "Don't lose me"
    window.send_keys(an_important_string)
    an_important_string.should == "Don't lose me"
  end

  it "#control" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.control(:id => "aboutButton").should exist
  end

  it "has controls" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)
    window.controls(:class => /BUTTON/i).size.should == 12
  end

  it "window coordinates" do
    window = RAutomation::Window.new(:title => /MainFormWindow/i)

    window.maximize
    window.bounding_rectangle.should == [-4, -4, 1444, 874]
  end
=end
end
