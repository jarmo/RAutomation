require 'spec_helper'

include RAutomation::Adapter

describe MsUia::TabControl do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow', :adapter => :ms_uia) }
  let(:about) { RAutomation::Window.new(:title => 'About', :adapter => :ms_uia) }
  subject { about.tab_control(:id => 'tabControl') }

  before(:each) do
    window.button(:value => 'About').click { true }
  end

  it { should exist }

  it 'has tab items' do
    subject.items.count.should eq(2)
  end
end
