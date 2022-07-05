require 'spec_helper'

describe "Win32::SelectList", if: SpecHelper.adapter == :win_32 do
  let(:window) { RAutomation::Window.new(title: "MainFormWindow") }
  it "#select_list" do
    expect(window.select_list(class: /combobox/i, index: 1)).to exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: "non-existent-window").
            select_list(class: /combobox/i, index: 1)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "#options" do
    select_list = window.select_list(class: /combobox/i, indexv: 1)
    expect(select_list.options.size).to eq(5)

    expected_options = ["Apple", "Caimito", "Coconut", "Orange", "Passion Fruit"]
    expect(select_list.options.map {|option| option.text}).to be == expected_options
  end

  it "#selected? & #select" do
    select_list = window.select_list(class: /combobox/i, index: 1)
    expect(select_list.options(text: "Apple")[0].selected?).to_not be true
    expect(select_list.options(text: "Apple")[0].select).to be true
    expect(select_list.options(text: "Apple")[0].selected?).to be true
  end

  it "#set" do
    select_list = window.select_list(class: /combobox/i, index: 1)
    expect(select_list.options(text: "Apple")[0].selected?).to_not be true
    select_list.set("Apple")
    expect(select_list.options(text: "Apple")[0].selected?).to be true
  end

  it "#value" do
    select_list = window.select_list(class: /combobox/i, index: 1)

    #default empty state
    expect(select_list.value).to be == ""

    select_list.options(text: "Apple")[0].select
    expect(select_list.value).to be == "Apple"

    select_list.options(text: "Caimito")[0].select
    expect(select_list.value).to be == "Caimito"
  end

  it "enabled/disabled" do
    expect(window.select_list(class: /combobox/i, index: 1).enabled?).to be true
    expect(window.select_list(class: /combobox/i, index: 1).enabled?).to_not be false
  end

  it "#option" do
    select_list = window.select_list(class: /combobox/i, index: 1)

    expect(select_list.option(text: "Apple").selected?).to_not be true
    select_list.option(text: "Apple").set
    expect(select_list.option(text: "Apple").selected?).to be true
  end

  it "cannot select anything on a disabled select list" do
    expect { window.select_list(id: "comboBoxDisabled").option(text: "Apple").set }.to raise_error(TypeError)
  end
end
