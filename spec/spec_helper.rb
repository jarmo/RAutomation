$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'RAutomation'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  config.before(:all) do
    @ie = IO.popen('"c:\\program files\\internet explorer\\iexplore.exe" http://dl.dropbox.com/u/2731643/RAutomation/test.html').pid
    window = RAutomation::Window.new(/file download/i)
    RAutomation::WaitHelper.wait_until(10) {window.present?}
  end

  config.after(:all) do
    Process.kill(9, @ie) rescue nil
  end
end
