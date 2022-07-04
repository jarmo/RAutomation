require 'spec_helper'

describe 'MsUia::SelectList', if: SpecHelper.adapter == :ms_uia do
  let(:window) { RAutomation::Window.new(title: 'MainFormWindow') }
  let(:fruits_combo) { window.select_list(id: 'FruitsComboBox') }
  let(:fruits_list) { window.select_list(id: 'FruitListBox') }
  let(:fruit_label) { window.label(id: 'fruitsLabel') }
  let(:disabled_combo) { window.select_list(id: 'comboBoxDisabled') }
  let(:about) do
    window.button(value: 'About').click { true }
    about = RAutomation::Window.new(title: 'About')
  end
  let(:multi_fruits) do
    about.tab_control(id: 'tabControl').set 'Multi-Select ListBox'
    about.select_list(id: 'multiFruitListBox')
  end

  it '#select_list' do
    expect(fruits_combo.exist?).to be true

    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(title: 'non-existent-window').
            select_list(class: /COMBOBOX/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it 'check for select list class' do
    expect(window.select_list(id: 'textField').exist?).to_not be true
    expect(fruits_combo.exist?).to be true
  end

  context 'SelectListOption' do
    it '#selected? & #select' do
      expect(fruits_combo.options(text: 'Apple')[0].selected?).to_not be true
      expect(fruits_combo.options(text: 'Apple')[0].select).to be true
      expect(fruits_combo.options(text: 'Apple')[0].selected?).to be true
    end

    it '#value' do

      #default empty state
      expect(fruits_combo.value).to be == ''

      fruits_combo.options(text: 'Apple')[0].select
      expect(fruits_combo.value).to be == 'Apple'

      fruits_combo.options(text: 'Caimito')[0].select
      expect(fruits_combo.value).to be == 'Caimito'
    end

    it 'enabled/disabled' do
      expect(fruits_combo.enabled?).to be true
      expect(fruits_combo.disabled?).to_not be true

      expect(disabled_combo.enabled?).to_not be true
      expect(disabled_combo.disabled?).to be true
    end
  end

  it '#select' do
    multi_fruits.select text: /ng/
    expect(multi_fruits.values).to eq(['Orange', 'Mango'])
  end

  it '#clear' do
    multi_fruits.select # select all
    multi_fruits.clear text: 'Orange'
    expect(multi_fruits.values).to eq(['Apple', 'Mango'])
  end

  it '#values' do
    expect(multi_fruits.values).to eq([]) # => empty state

    ['Apple', 'Mango'].each do |value|
      multi_fruits.option(text: value).select
    end
    expect(multi_fruits.values).to eq(['Apple', 'Mango'])
  end

  it '#option' do
    expect(fruits_combo.option(text: 'Apple').selected?).to_not be true
    fruits_combo.option(index: 0).set
    expect(fruits_combo.option(text: 'Apple').selected?).to be true
  end

  it '#options' do
    expect(fruits_combo.options.size).to be == 5
    expect(fruits_combo.options.map(&:text)).to eq(['Apple', 'Caimito', 'Coconut', 'Orange', 'Passion Fruit'])

    expect(fruits_combo.options(text: 'Apple').map(&:text)).to eq ['Apple']
    expect(fruits_combo.options(text: /Ap{2}le/).map(&:text)).to eq ['Apple']
    expect(fruits_combo.options(index: 0).map(&:text)).to eq ['Apple']
  end

  it 'cannot select anything on a disabled select list' do
    expect { disabled_combo.option(text: 'Apple').set }.to raise_error(RuntimeError)
  end

  it 'fires change event when the value is set' do
    apple_option = fruits_combo.option(text: 'Apple')
    expect(apple_option.selected?).to_not be true
    apple_option.select
    expect(apple_option.selected?).to be true

    RAutomation::WaitHelper.wait_until { fruit_label.exist? }
    expect(fruit_label.value).to be == 'Apple'
  end

  it 'fires change event when the index changes' do
    fruits_combo.options[4].select
    expect(fruits_combo.option(text: 'Passion Fruit').selected?).to be true
    expect(fruit_label.value).to be == 'Passion Fruit'

    fruits_combo.options[3].select
    expect(fruits_combo.option(text: 'Orange').selected?).to be true
    expect(fruit_label.value).to be == 'Orange'
  end
end
