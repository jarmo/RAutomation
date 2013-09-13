require 'spec_helper'

include RAutomation::Adapter

describe MsUia::TabControl, :if => SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow') }
  let(:about) { RAutomation::Window.new(:title => 'About') }
  subject { about.tab_control(:id => 'tabControl') }

  before(:each) do
    window.button(:value => 'About').click { true }
  end

  it { should exist }

  it '#select' do
    subject.select(1)
    subject.value.should eq('More Info')
  end

  it '#set' do
    subject.set 'More Info'
    subject.value.should eq('More Info')
  end

  it 'has tab items' do
    subject.items.count.should eq(3)
  end

  it 'knows the current tab' do
    subject.value.should eq('Info')
  end

  context('#items') do
    it 'has text' do
      subject.items.map(&:text).should eq(['Info', 'More Info', 'Multi-Select ListBox'])
    end

    it 'has indices' do
      subject.items.map(&:index).should eq([0, 1, 2])
    end

    it 'can be selected' do
      subject.items.find {|t| t.text == 'More Info'}.select
      subject.value.should eq('More Info')
    end

    it 'knows if it is selected' do
      subject.items.first.should be_selected
      subject.items.last.should_not be_selected
    end
  end
end
