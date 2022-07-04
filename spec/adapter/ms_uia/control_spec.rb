require "spec_helper"

describe "MsUia::Control", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: /MainFormWindow/i) }

  context '#click' do
    it 'stops trying after the window goes away' do
      window.button(value: 'About').click { true }

      RAutomation::Window.new(title: 'About').button(id: 'button1').click
    end
  end

  it "control coordinates", special: false do
    window.maximize
    control = window.control(id: "radioButtonReset")
    expect(control.bounding_rectangle).to be_all {|coord| coord.between?(200, 400)}
  end

   it "control process id", special: true do
    control = window.control(id: "radioButtonReset")
    expect(control.new_pid).to be == @pid1
   end

  it "has a class" do
    control = window.control(id: "radioButtonReset")
    expect(control.control_class).to be =~ /WindowsForms10.BUTTON.*/
  end

  it "can get tooltip information" do
    control = window.button(value: 'Reset')
    expect(control.help_text).to eq 'Some help text'
  end

  it "can limit the search depth" do
    window.button(id: 'buttonDataGridView').click { true }
    data_grid_window = RAutomation::Window.new(title: /DataGridView/i)

    start = Time.new
    data_grid_window.button(id: 'buttonClose', children_only: true).exist?
    elapsed_time = Time.new - start
    expect(elapsed_time).to be < 2
  end

  context RAutomation::Adapter::MsUia::UiaDll::SearchCriteria, pure_unit: true do
    let(:window) { double('RAutomation Window').as_null_object }
    let(:locator) { {id: 'someId'} }
    let(:control) { RAutomation::Adapter::MsUia::Control.new(window, locator) }
    let(:old_style_control) { RAutomation::Adapter::MsUia::Control.new(window, class: 'someClass') }
    let(:expect_a_handle) { expect(RAutomation::Adapter::MsUia::UiaDll).to receive(:cached_hwnd).once.and_return(456) }
    let(:expect_no_handle) { expect(RAutomation::Adapter::MsUia::UiaDll).to receive(:cached_hwnd).once.and_return(0) }
    subject { control.search_information }

    before(:each) do
      expect(window).to receive(:hwnd).at_least(:once).and_return(123)
      allow(RAutomation::Adapter::MsUia::Functions).to receive(:control_hwnd)
    end

    it "uses the cached window handle if it has one" do
      expect_a_handle
      expect(subject.how).to eq(:hwnd)
      expect(subject.data).to eq(456)
    end

    it "only asks for the window handle once" do
      expect_a_handle
      2.times { control.search_information }
    end

    it "uses the locator specified when no window handle is present" do
      expect_no_handle
      expect(subject.how).to eq(:id)
      expect(subject.data).to eq('someId')
    end

    it "tries the old way of locating the window handle if no UIA locator is provided" do
      expect_no_handle
      expect(RAutomation::Adapter::MsUia::Functions).to receive(:control_hwnd)
                                                                .with(window.hwnd, index: 0, class: 'someClass')
                                                                .and_return(789)
      old_info = old_style_control.search_information
      expect(old_info.how).to eq(:hwnd)
      expect(old_info.data).to eq(789)
    end

  end

end
