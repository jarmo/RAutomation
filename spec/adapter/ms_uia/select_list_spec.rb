require 'spec_helper'

describe 'MsUia::SelectList', :if => SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow') }
  let(:fruits_combo) { window.select_list(:id => 'FruitsComboBox') }
  let(:fruits_list) { window.select_list(:id => 'FruitListBox') }
  let(:fruit_label) { window.label(:id => 'fruitsLabel') }
  let(:disabled_combo) { window.select_list(:id => 'comboBoxDisabled') }

  it '#fruits_combo' do
    fruits_combo.should exist

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => 'non-existent-window').
            select_list(:class => /COMBOBOX/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it 'check for select list class' do
    window.select_list(:id => 'textField').should_not exist
    fruits_combo.should exist
  end

  it '#options' do
    fruits_combo.options.size.should == 5

    expected_options = ['Apple', 'Caimito', 'Coconut', 'Orange', 'Passion Fruit']
    fruits_combo.options.map {|option| option.text}.should == expected_options
  end

  it '#selected? & #select' do
    fruits_combo.options(:text => 'Apple')[0].should_not be_selected
    fruits_combo.options(:text => 'Apple')[0].select.should be_true
    fruits_combo.options(:text => 'Apple')[0].should be_selected
  end

  it '#set' do
    fruits_combo.options(:text => 'Apple')[0].should_not be_selected
    fruits_combo.set('Apple')
    fruits_combo.options(:text => 'Apple')[0].should be_selected
  end

  it '#value' do

    #default empty state
    fruits_combo.value.should == ''

    fruits_combo.options(:text => 'Apple')[0].select
    fruits_combo.value.should == 'Apple'

    fruits_combo.options(:text => 'Caimito')[0].select
    fruits_combo.value.should == 'Caimito'
  end

  it 'enabled/disabled' do
    fruits_combo.should be_enabled
    fruits_combo.should_not be_disabled

    disabled_combo.should_not be_enabled
    disabled_combo.should be_disabled
  end

  it '#add' do
    fruits_list.add(0, 1)
    fruit_label.value.should eq('Apple,Orange')

    fruits_list.add('Mango')
    fruit_label.value.should eq('Apple,Orange,Mango')
  end

  it '#remove' do
    fruits_list.add('Apple', 'Orange', 'Mango')

    fruits_list.remove('Orange')
    fruits_list.values.should eq(['Apple', 'Mango'])

    fruits_list.remove(0) # => 'Apple'
    fruits_list.values.should eq(['Mango'])
  end

  it '#values' do
    fruits_list.add('Apple', 'Mango')
    fruits_list.values.should eq(['Apple', 'Mango'])
  end

  it '#option' do
    fruits_combo.option(:text => 'Apple').should_not be_selected
    fruits_combo.option(:text => 'Apple').set
    fruits_combo.option(:text => 'Apple').should be_selected
  end

  it 'cannot select anything on a disabled select list' do
    lambda { disabled_combo.option(:text => 'Apple').set }.should raise_error
  end

  it 'fires change event when the value is set' do
    fruits_combo.option(:text => 'Apple').should_not be_selected
    fruits_combo.set('Apple')
    fruits_combo.option(:text => 'Apple').should be_selected

    RAutomation::WaitHelper.wait_until { fruit_label.exist? }
    fruit_label.value.should == 'Apple'
  end

  it 'fires change event when the index changes' do
    fruits_combo.options[4].select
    fruits_combo.option(:text => 'Passion Fruit').should be_selected
    fruit_label.value.should == 'Passion Fruit'

    fruits_combo.select 3
    fruits_combo.option(:text => 'Orange').should be_selected
    fruit_label.value.should == 'Orange'
  end
end
