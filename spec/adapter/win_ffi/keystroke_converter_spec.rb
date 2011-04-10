$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'rspec'

describe "KeystrokeConverter" do

  it "convert plain ASCII" do
    codes = RAutomation::Adapter::WinFfi::KeystrokeConverter.convert("abc")
    codes[0].should == "a".unpack("c")[0]
    codes[1].should == "b".unpack("c")[0]
    codes[2].should == "c".unpack("c")[0]
  end

  it "convert key names" do
    codes = RAutomation::Adapter::WinFfi::KeystrokeConverter.convert("{tab}a{backspace}b{enter}c{space}")
    codes[0].should == RAutomation::Adapter::WinFfi::Constants::VK_TAB
    codes[1].should == "a".unpack("c")[0]
    codes[2].should == RAutomation::Adapter::WinFfi::Constants::VK_BACK
    codes[3].should == "b".unpack("c")[0]
    codes[4].should == RAutomation::Adapter::WinFfi::Constants::VK_RETURN
    codes[5].should == "c".unpack("c")[0]
    codes[6].should == RAutomation::Adapter::WinFfi::Constants::VK_SPACE
  end

end
