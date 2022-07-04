require 'spec_helper'

include RAutomation::Adapter

describe MsUia::TabControl, if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: 'MainFormWindow') }
  let(:about) { RAutomation::Window.new(title: 'About') }
  subject { about.tab_control(id: 'tabControl') }

  before(:each) do
    window.button(value: 'About').click { true }
  end

  it { should exist }

  it '#select' do
    subject.select(1)
    expect(subject.value).to eq('More Info')
  end

  it '#set' do
    subject.set 'More Info'
    expect(subject.value).to eq('More Info')
  end

  it 'has tab items' do
    expect(subject.items.count).to eq(3)
  end

  it 'knows the current tab' do
    expect(subject.value).to eq('Info')
  end

  context('#items') do
    it 'has text' do
      expect(subject.items.map(&:text)).to eq(['Info', 'More Info', 'Multi-Select ListBox'])
    end

    it 'has indices' do
       expect(subject.items.map(&:index)).to eq([0, 1, 2])
    end

    it 'can be selected' do
      subject.items.find {|t| t.text == 'More Info'}.select
      expect(subject.value).to eq('More Info')
    end

    it 'knows if it is selected' do
      expect(subject.items.first.selected?).to be true
      expect(subject.items.last.selected?).to_not be true
    end
  end
end
