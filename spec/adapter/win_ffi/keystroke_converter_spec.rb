$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'rspec'

describe "KeystrokeConverter" do

  it "convert plain ASCII" do
    converter = RAutomation::Adapter::WinFfi::KeystrokeConverter.new
    codes = converter.convertKeyCodes("abc")
    codes[0].should == "a"[0].ord
    codes[1].should == "b"[0].ord
    codes[2].should == "c"[0].ord
  end

  it "convert key names" do
    converter = RAutomation::Adapter::WinFfi::KeystrokeConverter.new
    codes = converter.convertKeyCodes("{tab}a{backspace}b{enter}c{space}")
    codes[0].should == RAutomation::Adapter::WinFfi::Constants::VK_TAB
    codes[1].should == "a"[0].ord
    codes[2].should == RAutomation::Adapter::WinFfi::Constants::VK_BACK
    codes[3].should == "b"[0].ord
    codes[4].should == RAutomation::Adapter::WinFfi::Constants::VK_RETURN
    codes[5].should == "c"[0].ord
    codes[6].should == RAutomation::Adapter::WinFfi::Constants::VK_SPACE
  end

end
