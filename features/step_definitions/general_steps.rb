Given /^I am on the main form$/ do
  @main_form = MainForm.new
  fail "Main form not visible" unless @main_form.visible?
end

When /^I open the about dialog box$/ do
  @main_form.open_about_dialog
end

Then /^I see the about dialog box$/ do
  @about_dialog = AboutDialog.new
  fail "About dialog not visible" unless @about_dialog.visible?
end

Then /^I see the label change to "([^\"]*)"$/ do |expected_label_text|
  actual_label_text = @main_form.checkbox_label_text
  fail "Expected label text '#{expected_label_text}' but was '#{actual_label_text}'" unless actual_label_text.eql? expected_label_text
end

When /^I select the check box$/ do
  @main_form.select_checkbox
end

When /^the check box is ticked$/ do
  fail "Checkbox not ticked" unless @main_form.checkbox_ticked?
end

Given /^I press data entry form button$/ do
  @main_form.click_data_entry_form_button
  @data_entry_form = DataEntryForm.new
end
Then /^I see the table:$/ do |table|
  # table is a | Anna Doe | 3/4/75     |
  table.diff!(@data_entry_form.my_data_table)
end
When /^I don't selected anything on the combo box$/ do

end
Then /^I expect to "([^\"]*)" in the combo box$/ do |combo_box_value|
  @main_form.combo_box_value.should == combo_box_value
end
When /^I select "([^\"]*)" in the combo box$/ do |combo_box_selection|
  @main_form.set_combo_box_to(combo_box_selection)
end

When /^I set the radio button to "([^\"]*)"$/ do |radio_button_name|
  @main_form.click_radio_button(radio_button_name)
end
Then /^I the radio button "([^\"]*)" should be set$/ do |radio_button_name|
  @main_form.radio_button(radio_button_name).set?.should == true
end
When /^I the radio button "([^\"]*)" should be not set$/ do |radio_button_name|
  @main_form.radio_button(radio_button_name).set?.should == false
end
Then /^the selected label says "([^\"]*)"$/ do |label_text|
  fail "Label named \"#{label_text}\" does not exist" unless @main_form.label_exist?(label_text)
end