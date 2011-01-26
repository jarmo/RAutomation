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
