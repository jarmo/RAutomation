$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'rspec'

describe "KeystrokeConverter" do

  it "convert plain ASCII" do
    converter = RAutomation::Adapter::WinFfi::KeystrokeConverter.new
    codes = converter.convertKeyCodes("abc")
    codes[0].should == "a".ord
    codes[1].should == "b".ord
    codes[2].should == "c".ord
  end

  it "convert key names" do
    converter = RAutomation::Adapter::WinFfi::KeystrokeConverter.new
    codes = converter.convertKeyCodes("{tab}a")
    codes[0].should == RAutomation::Adapter::WinFfi::Constants::VK_TAB
    codes[1].should == "a".ord
  end

end
