$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rautomation'
require 'rspec'

describe "KeystrokeConverter", :if => SpecHelper.adapter == :ms_uia do

  it "converts plain ASCII" do
    codes = RAutomation::Adapter::Win32::KeystrokeConverter.convert("abc")
    converted_keys = convert_keys "abc"
    codes.should == converted_keys
  end

  it "uses caps lock for entering downcase keys" do
    codes = RAutomation::Adapter::Win32::KeystrokeConverter.convert("aBc")
    converted_keys = convert_keys "abc"
    converted_keys = converted_keys.insert(1, RAutomation::Adapter::Win32::Constants::VK_LSHIFT)
    codes.should == converted_keys
  end

  it "converts special keys" do
    codes = RAutomation::Adapter::Win32::KeystrokeConverter.convert("{tab}a{backspace}b{enter}c {left}d{right}ee{down}f{up}g{unsupported}{home}{end}{delete}")
    expected_codes = [
        RAutomation::Adapter::Win32::Constants::VK_TAB,
        convert_keys("a"),
        RAutomation::Adapter::Win32::Constants::VK_BACK,
        convert_keys("b"),
        RAutomation::Adapter::Win32::Constants::VK_RETURN,
        convert_keys("c"),
        RAutomation::Adapter::Win32::Constants::VK_SPACE,
        RAutomation::Adapter::Win32::Constants::VK_LEFT,
        convert_keys("d"),
        RAutomation::Adapter::Win32::Constants::VK_RIGHT,
        convert_keys("ee"),
        RAutomation::Adapter::Win32::Constants::VK_DOWN,
        convert_keys("f"),
        RAutomation::Adapter::Win32::Constants::VK_UP,
        convert_keys("g"),
        convert_keys("unsupported"),
        RAutomation::Adapter::Win32::Constants::VK_HOME,
        RAutomation::Adapter::Win32::Constants::VK_END,
        RAutomation::Adapter::Win32::Constants::VK_DELETE


    ].flatten
    codes.should == expected_codes
  end

  def convert_keys keys
    keys.split("").map { |k| k.upcase.unpack("c")[0] }
  end

end
