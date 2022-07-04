require "spec_helper"

describe "MsUia::Window", if: SpecHelper.adapter == :ms_uia do
  let(:window) {RAutomation::Window.new(title: /MainFormWindow/i)}

  it "move and click" do
    window.maximize
    window.move_mouse(62,46)
    sleep 1
    window.click_mouse
    sleep 1
  end

  context "#send_keys" do
    it "send tab keystrokes to move focus between elements" do
      window.button(value: "About").focus
      expect(window.button(value: "About").focused?).to be true

      window.send_keys(:tab, :tab, :tab)
      button = window.button(value: "Close")
      expect(button.exist?).to be true
      expect(button.focused?).to be true
    end

    it "send arbitrary characters and control keys" do
      text_field = window.text_field(index: 2)
      text_field.focus
      window.send_keys("abc123ABChiHI!")
      expect(text_field.value).to be == "abc123ABChiHI!"

      window.send_keys(:space, "X")
      expect(text_field.value).to be == "abc123ABChiHI! X"

      window.send_keys([:control, "a"], :backspace)
      expect(text_field.value.empty?).to be true
    end
  end

  context "#control" do
    it "by name" do
      expect(window.control(name: "checkBox").exist?).to be true
    end
  end

  context "menu items" do
    let(:about_box) { RAutomation::Window.new title: "About" }

    it "can select menu items" do
      window.menu(text: "File").menu(text: "About").open
      RAutomation::WaitHelper.wait_until { about_box.present? }
    end

    it "can select deep menu items" do
      window.menu(text: "File")
            .menu(text: "Roundabout Way")
            .menu(text: "About").open
      RAutomation::WaitHelper.wait_until { about_box.present? }
    end

    it "raises when errors occur" do
      expect { window.menu(text: "File").menu(text: "Does Not Exist").open}.to raise_error(RuntimeError)
    end

    it "indicates if the menu item does not exist" do
      begin
        window.menu(text: "File").menu(text: "Should Not Exist").open
        fail "Should have failed to find the menu item"
      rescue Exception => e
         expect(e.message).to match(/MenuItem with the text "Should Not Exist" does not exist/)
      end
    end

    it "knows when menu items exist" do
      expect(window.menu(text: "File").menu(text: "About").exists?).to be true
    end

    it "knows when menu items do not exist" do
      expect(window.menu(text: "File").menu(text: "Missing").exists?).to_not be true
    end
  end
end
