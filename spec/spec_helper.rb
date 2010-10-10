$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'spec'
require 'spec/autorun'

module SpecHelper
  # Since implementations are different then the windows to be tested
  # might be different also.
  #
  # Allows to create data for specs which could be differ between the implementations.
  #
  # There has to be 3 windows:
  # 1) Some random window, which is maximizable/minimizable and close'able.
  # 2) Window with some visible text and a button, which would open window3 if pressed.
  #    That should be also 'clickable' with the keyboard.
  # 3) Window, which should be opened when clicking button on window 2. This window should have also
  #    at least 1 text field.
  DATA = {
          # This implementation needs Windows OS with Internet Explorer installed into 'c:\program files\internet explorer'
          # and an Internet connection.
          "RAutomation::Implementations::AutoIt::Window" => {
                  # Binary, which will be ran in before :all to open windows to test.
                  :bin => '"c:\\program files\\internet explorer\\iexplore.exe" http://dl.dropbox.com/u/2731643/RAutomation/test.html',
                  # Window title 1, has to be String.
                  :window1_title => "RAutomation testing page - Windows Internet Explorer",
                  # Window title 2, has to be Regexp.
                  :window2_title => /file download/i,
                  # This text should exist on window2.
                  :window2_text => "Do you want to open or save this file?",
                  # When pressing ALT+s, the window2 button should be pressed.
                  :window2_send_keys => "!s", # ALT+s == save
                  # Window 2 should have a button with the following text.
                  :window2_button_text => "&Save",
                  # Window title 3 can be String or Regexp.
                  :window3_title => "Save As",
                  # Window 3 should have a text field with the specified class name.
                  :window3_text_field_class_name => "Edit1"

          }
  }[ENV["RAUTOMATION_IMPLEMENTATION"] || RAutomation::Implementations::Helper.default_implementation.to_s]
end

Spec::Runner.configure do |config|
  config.before(:all) do
    @bin = IO.popen(SpecHelper::DATA[:bin]).pid
    window1 = RAutomation::Window.new(:title => SpecHelper::DATA[:window1_title])
    RAutomation::WaitHelper.wait_until(15) {window1.present?}
    window2 = RAutomation::Window.new(:title => SpecHelper::DATA[:window2_title])
    RAutomation::WaitHelper.wait_until(15) {window2.present?}
  end

  config.after(:all) do
    Process.kill(9, @bin) rescue nil
  end
end
