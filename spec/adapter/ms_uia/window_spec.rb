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
      window.button(:value => "About").focus
      window.button(:value => "About").should be_focused

      window.send_keys(:tab, :tab, :tab)
      button = window.button(:value => "Close")
      button.should exist
      button.should be_focused
    end

    it "send arbitrary characters and control keys" do
      text_field = window.text_field(:index => 2)
      text_field.focus
      window.send_keys "abc123ABChiHI!"
      text_field.value.should == "abc123ABChiHI!"

      window.send_keys :space, "X"
      text_field.value.should == "abc123ABChiHI! X"

      window.send_keys [:control, "a"], :backspace
      text_field.value.should be_empty
    end
  end

  context "#control" do
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
      expect { window.menu(:text => "File").menu(:text => "Does Not Exist").open}.to raise_error
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
end
