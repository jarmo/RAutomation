require 'spec_helper'
require 'watir'

describe "Unit Tests for move_window" do
  before :all do
    @browser = Watir::Browser.new
    @browser.goto 'www.google.com'
    @window = RAutomation::Window.new(:title => /Google/)
  end

  it "set window width:500, height:500, xPos:0, yPos:0" do
    @window.move_window(500, 500, 0, 0)
    @window.get_window_rect()[3].should == 500
    @window.get_window_rect()[2].should == 500
  end

  it "set window width:800, height:1000, xPos:20, yPos:40" do
    @window.move_window(800, 1000, 20, 40)
    @window.get_window_rect()[3].should == 1040
    @window.get_window_rect()[2].should == 820
  end

  it "set window width:270, height:500, xPos:20, yPos:40" do
    @window.move_window(270, 500)
    @window.get_window_rect()[3].should == 540
    @window.get_window_rect()[2].should == 290
  end
end