require 'spec_helper'

include RAutomation::Adapter

describe MsUia::Spinner do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow') }
  subject { window.spinner(:id => 'numericUpDown1') }

  it { should exist }

  it '#set' do
    subject.set 4.0
    subject.value.should eq(4.0)
  end
end
