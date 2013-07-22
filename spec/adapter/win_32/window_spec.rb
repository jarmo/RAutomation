require "spec_helper"

describe "Win32::Window", :if => SpecHelper.adapter == :win_32 do
  let(:window) {RAutomation::Window.new(:title => /MainFormWindow/i)}

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

  it "#control" do
    window.control(:value => "&About").should exist
  end

  it "#controls" do
    window.controls(:class => /button/i).size.should == 13
  end

  context "#move" do
    it "width=500, height=400, left=10, top=0" do
      window.move :width => 500, :height => 400, :left => 10, :top => 0
      coords = window.dimensions
      coords[:width].should == 500
      coords[:height].should == 400
      coords[:left].should == 10
      coords[:top].should == 0
    end

    it "uses default dimensions if not specified" do
      coords = window.dimensions
      window.move :width => 253, :left => 26

      new_coords = window.dimensions
      new_coords[:width].should == 253
      new_coords[:left].should == 26
      new_coords[:top].should == coords[:top]
      new_coords[:height].should == coords[:height]
    end
  end
end
