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

  it 'likes for values to be within range' do
    lambda { subject.set(1000.0) }.should raise_error
  end

  it '#increment' do
    subject.set 5.0
    subject.increment.should eq(6.0)
  end

  it '#decrement' do
    subject.set 5.0
    subject.decrement.should eq(4.0)
  end
end
