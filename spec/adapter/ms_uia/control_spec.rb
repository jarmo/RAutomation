require "spec_helper"

describe "MsUia::Control", :if => SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(:title => /MainFormWindow/i) }

  it "control coordinates", :special => false do
    window.maximize
    control = window.control(:id => "radioButtonReset")
    control.bounding_rectangle.should be_all {|coord| coord.between?(200, 400)}
  end

   it "control process id", :special => true do
    control = window.control(:id => "radioButtonReset")
    control.new_pid.should == @pid1
   end

  it "has a class" do
    control = window.control(:id => "radioButtonReset")
    control.control_class.should =~ /WindowsForms10.BUTTON.app.0.2bf8098_r1[0-9]_ad1/
  end

  context RAutomation::Adapter::MsUia::UiaDll::SearchCriteria, :pure_unit => true do
    let(:window) { double('RAutomation Window').as_null_object }
    let(:locator) { {:id => 'someId'} }
    let(:control) { RAutomation::Adapter::MsUia::Control.new(window, locator) }
    let(:old_style_control) { RAutomation::Adapter::MsUia::Control.new(window, :class => 'someClass') }
    let(:expect_a_handle) { RAutomation::Adapter::MsUia::UiaDll.should_receive(:cached_hwnd).once.and_return(456) }
    let(:expect_no_handle) { RAutomation::Adapter::MsUia::UiaDll.should_receive(:cached_hwnd).once.and_return(0) }
    subject { control.search_information }

    before(:each) do
      window.should_receive(:hwnd).at_least(:once).and_return(123)
      RAutomation::Adapter::MsUia::Functions.stub(:control_hwnd)
    end

    it "uses the cached window handle if it has one" do
      expect_a_handle
      subject.how.should eq(:hwnd)
      subject.data.should eq(456)
    end

    it "only asks for the window handle once" do
      expect_a_handle
      2.times { control.search_information }
    end

    it "uses the locator specified when no window handle is present" do
      expect_no_handle
      subject.how.should eq(:id)
      subject.data.should eq('someId')
    end

    it "tries the old way of locating the window handle if no UIA locator is provided" do
      expect_no_handle
      RAutomation::Adapter::MsUia::Functions.should_receive(:control_hwnd).with(window.hwnd, :index => 0, :class => 'someClass').and_return(789)
      old_info = old_style_control.search_information
      old_info.how.should eq(:hwnd)
      old_info.data.should eq(789)
    end

  end

end
