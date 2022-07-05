require 'spec_helper'

describe RAutomation::Window do
  it ".adapter" do
     expect(RAutomation::Window.new(title: "random").adapter)
             .to be == (ENV["RAUTOMATION_ADAPTER"] && ENV["RAUTOMATION_ADAPTER"].to_sym || RAutomation::Adapter::Helper.default_adapter)
  end

  it "#new by full title" do
     expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_full_title]).exist?).to be true
  end

  it "#new by regexp title" do
     expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).exist?).to be true
  end

  it "#new by hwnd" do
    hwnd = RAutomation::Window.new(title: SpecHelper::DATA[:window1_full_title]).hwnd
    window = RAutomation::Window.new(hwnd: hwnd)
    expect(window.exist?).to be true
    expect(window.title).to be == SpecHelper::DATA[:window1_full_title]
  end

  it "#exists?" do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).exist?).to be true
    expect(RAutomation::Window.new(title: "non-existing-window").exist?).to_not be true
  end

  it "#visible?"do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).visible?).to be true
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").visible?}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#present?"do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).present?).to be true
    expect(RAutomation::Window.new(title: "non-existing-window").present?).to_not be true
  end

  it "#hwnd" do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).hwnd).to be_a(Integer)
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").hwnd}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#title" do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).title).to be == SpecHelper::DATA[:window1_full_title]
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").title}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#class_names" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])

    fail "Expected class name not found." unless window.class_names.any? {|clazz| clazz.match(/WindowsForms10\.Window\.8\.app\.0\.\S+_r\d+_ad1/)}

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").class_names}.
            to raise_exception(RAutomation::UnknownWindowException)    
  end

  it "#activate & #active?" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    window.activate
    expect(window.active?).to be true
    non_existing_window = RAutomation::Window.new(title: "non-existing-window")
    non_existing_window.activate
    expect(non_existing_window.active?).to_not be true
  end

  it "#text" do
    expect(RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).text).to include(SpecHelper::DATA[:window1_text])
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").text}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#maximize" do
    RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).maximize
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").maximize}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#minimize & #minimized?" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect(window.minimized?).to_not be true
    window.minimize
    expect(window.minimized?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").minimize}.
            to raise_exception(RAutomation::UnknownWindowException)
    expect {RAutomation::Window.new(title: "non-existing-window").minimized?}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#restore" do
    RAutomation::Window.new(title: SpecHelper::DATA[:window1_title]).restore
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").restore}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#method_missing" do
    win = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect(SpecHelper::DATA[:title_proc].call(win)).to be == SpecHelper::DATA[:window1_full_title]
  end

  it "#send_keys"do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    window.minimize # send_keys should work even if window is minimized
    window.send_keys(SpecHelper::DATA[:window1_send_keys])
    SpecHelper::DATA[:proc_after_send_keys].call

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existing-window").send_keys("123")}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#close" do
    window = RAutomation::Window.new(title: SpecHelper::DATA[:window1_title])
    expect(window.exist?).to be true
    window.close
    expect(window.exist?).to_not be true

    expect {RAutomation::Window.new(title: "non-existing-window").close}.
            to_not raise_exception
  end

  context '#child', if: [:win_32, :ms_uia].include?(SpecHelper.adapter) do
    let(:window) { RAutomation::Window.new(title: SpecHelper::DATA[:window1_full_title]) }

    it 'immediate children' do
      # buttons are windows too. so let's find the button for now
      child = window.child(title: '&About')
      expect(child.exist?).to be true
      expect(child.title).to be == "&About"
      expect(child.adapter).to be == SpecHelper.adapter
    end

    it 'popups' do
      window.button(title: '&About').click { true }
      expect(window.child(title: 'About').visible?).to be true
    end
  end
end
