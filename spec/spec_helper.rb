$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'spec'
require 'spec/autorun'

module SpecHelper
  # Since adapters are different then the windows to be tested
  # might be different also.
  #
  # This constant allows to create input data for specs which could differ between the adapters.
  #
  # There has to be 2 windows:
  # 1) Some random window, which is maximizable, minimizable, close'able and etc.
  # 2) Browser window, which opens up a test.html where JavaScript prompt with a Button and a TextField objects will be shown.
  DATA = {
          # This adapter needs Windows OS with Internet Explorer installed into 'c:\program files\internet explorer'.
          :autoit => {
                  # Path to some binary, which opens up a window, what can be
                  # minimized, maximized, activated, closed and etc.
                  :window1 => "mspaint",
                  # Window 1 title, has to be a Regexp.
                  :window1_title => /untitled - paint/i,
                  # Path to some browser's binary.
                  :window2 => '"c:\\program files\\internet explorer\\iexplore.exe"',
                  # Window 2 title, has to be a String.
                  :window2_title => "Explorer User Prompt",
                  # Window 2 should have this text on it.
                  :window2_text => "Where do you want to go today?",
                  # When sending ENTER on Window 2, then the window OK button should be pressed and Window 2 should be closed.
                  :window2_send_keys => "{ENTER}",
                  # Window 2 should have a button with the following text.
                  :window2_button_text => "OK",
                  # Window 2 should have a text field with the specified class name.
                  :window2_text_field_class_name => "Edit1"
          }
  }[ENV["RAUTOMATION_ADAPTER"] || RAutomation::Adapter::Helper.default_adapter]
end

Spec::Runner.configure do |config|
  config.before(:all) do
    @pid1 = IO.popen(SpecHelper::DATA[:window1]).pid
    @pid2 = IO.popen(SpecHelper::DATA[:window2] + " " + File.dirname(__FILE__) + "/test.html").pid
  end

  config.before(:each) do
    RAutomation::Window.wait_timeout = 60
  end

  config.after(:all) do
    Process.kill(9, @pid1) rescue nil
    Process.kill(9, @pid2) rescue nil
  end
end
