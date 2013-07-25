require 'spec_helper'

include RAutomation::Adapter

describe MsUia::TabControl do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow', :adapter => :ms_uia) }
  let(:about) { RAutomation::Window.new(:title => 'About', :adapter => :ms_uia) }

  before(:each) do
    window.button(:value => 'About').click { true }
  end

  it '#tab_control' do
    about.tab_control(:id => 'tabControl').should exist
  end
end
