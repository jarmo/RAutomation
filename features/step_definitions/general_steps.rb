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
