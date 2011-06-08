$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'rspec'

describe "KeystrokeConverter" do

  it "convert special keys" do
    converter = RAutomation::Adapter::WinFfi::KeystrokeConverter.new
    codes = converter.convertKeyCodes("abc{tab}123{backspace}ABC{enter}hi{space}HI{l_alt}{r_alt}{alt}{l_ctrl}{r_ctrl}{ctrl}{caps}{esc}{end}{home}{num_lock}{del}{ins}{shift}{l_shift}{r_shift}")

    codes[0].should == "a"
    codes[1].should == "b"
    codes[2].should == "c"
    codes[3].should == RAutomation::Adapter::WinFfi::Constants::VK_TAB
    codes[4].should == "1"
    codes[5].should == "2"
    codes[6].should == "3"
    codes[7].should == RAutomation::Adapter::WinFfi::Constants::VK_BACK
    codes[8].should == "A"
    codes[9].should == "B"
    codes[10].should == "C"
    codes[11].should == RAutomation::Adapter::WinFfi::Constants::VK_RETURN
    codes[12].should == "h"
    codes[13].should == "i"
    codes[14].should == RAutomation::Adapter::WinFfi::Constants::VK_SPACE
    codes[15].should == "H"
    codes[16].should == "I"
    codes[17].should == RAutomation::Adapter::WinFfi::Constants::VK_LMENU
    codes[18].should == RAutomation::Adapter::WinFfi::Constants::VK_RMENU
    codes[19].should == RAutomation::Adapter::WinFfi::Constants::VK_MENU
    codes[20].should == RAutomation::Adapter::WinFfi::Constants::VK_LCONTROL
    codes[21].should == RAutomation::Adapter::WinFfi::Constants::VK_RCONTROL
    codes[22].should == RAutomation::Adapter::WinFfi::Constants::VK_CONTROL
    codes[23].should == RAutomation::Adapter::WinFfi::Constants::VK_CAPITAL
    codes[24].should == RAutomation::Adapter::WinFfi::Constants::VK_ESCAPE
    codes[25].should == RAutomation::Adapter::WinFfi::Constants::VK_END
    codes[26].should == RAutomation::Adapter::WinFfi::Constants::VK_HOME
    codes[27].should == RAutomation::Adapter::WinFfi::Constants::VK_NUMLOCK
    codes[28].should == RAutomation::Adapter::WinFfi::Constants::VK_DELETE
    codes[29].should == RAutomation::Adapter::WinFfi::Constants::VK_INSERT
    codes[30].should == RAutomation::Adapter::WinFfi::Constants::VK_SHIFT
    codes[31].should == RAutomation::Adapter::WinFfi::Constants::VK_LSHIFT
    codes[32].should == RAutomation::Adapter::WinFfi::Constants::VK_RSHIFT
  end
end
