require 'spec_helper'

describe "MsUia::ValueControl", if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: /MainFormWindow/) }
  let(:value_control) { window.value_control(id: "automatableMonthCalendar1") }

  it "can set and get values" do
    value_control.set('12/25/2012')
    expect(value_control.value).to eq('12/25/2012')
  end
end
