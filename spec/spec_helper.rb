$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'spec'
require 'spec/autorun'

module SpecHelper
  DATA = {
          "RAutomation::Implementations::AutoIt::Window" => {
                  # binary, which will be ran in before :all to open windows to test
                  :bin => '"c:\\program files\\internet explorer\\iexplore.exe" http://dl.dropbox.com/u/2731643/RAutomation/test.html',
                  # window title 1, has to be String
                  :window1_title => "RAutomation testing page - Windows Internet Explorer",
                  # window title 2, has to be Regexp
                  :window2_title => /file download/i,
                  :window2_text => "Do you want to open or save this file?",
                  :window2_send_keys => "!s", # ALT+s == save
                  :window2_button_text => "&Save",
                  :window3_title => "Save As",
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
