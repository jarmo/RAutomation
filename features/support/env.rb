$:.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
$:.unshift File.join(File.dirname(__FILE__), '..', 'classes')

puts $:

require 'RAutomation'

SAMPLE_APP_EXE = "ext\\WindowsForms\\bin\\WindowsForms.exe"
