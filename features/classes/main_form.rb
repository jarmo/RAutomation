class MainForm

  def initialize
    @window = RAutomation::Window.new(:title => "MainFormWindow")
  end

  def visible?
    @window.visible?
  end

  def open_about_dialog
    button = @window.button(:value => "&About")
    button.click { RAutomation::Window.new(:title => "About").exists? }
  end

  def select_checkbox
    @window.checkbox(:value => "checkBox").set
  end

  def checkbox_label_text
    # index => 3 is really a bad way to find the element. I had to guess the index number
    @window.text_field(:class => /STATIC/i, :index => 3).value
  end

  def checkbox_ticked?
    @window.checkbox(:value => "checkBox").set?
  end

  def set_combo_box_to(combobox_value_to_set)
    @combo_box = @window.select_list(:class=>/COMBOBOX/i)
    @combo_box.options(:text=>combobox_value_to_set)[0].select
  end

  def combo_box_value
    @combo_box = @window.select_list(:class=>/COMBOBOX/i)
    @combo_box.value
  end

  def radio_button(radio_button_name)
    @window.radio(:value=>radio_button_name)
  end

  def click_radio_button(radio_button_name)
    @window.radio(:value=>radio_button_name).set
  end

  def click_data_entry_form_button
    @window.button(:title => 'Data Entry Form').click { RAutomation::Window.new(:title => 'DataEntryForm').exist? }
  end

  def label_exist?(value)
    @window.label(:value => value).exist?
  end

end
