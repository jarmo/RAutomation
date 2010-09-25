require "require_all"
require_rel "rautomation/wait"
require_rel "rautomation/window"
require_rel "rautomation/button"
require_rel "rautomation/text_field"

case RUBY_PLATFORM
  when /mswin|msys|mingw32/
    require_rel "rautomation/autoit.rb"
    RAutomation::Window.implementation = RAutomation::AutoIt::Window
  else
    raise "unsupported platform for RAutomation: #{RUBY_PLATFORM}"
end