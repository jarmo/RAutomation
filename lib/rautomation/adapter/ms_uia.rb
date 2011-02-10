begin
  gem "ffi"
rescue Gem::LoadError
  raise Gem::LoadError, "Unable to load FFI gem. Install it with:\n\tgem install ffi"
end
require "ffi"
require File.dirname(__FILE__) + "/ms_uia/uia_dll"
require File.dirname(__FILE__) + "/ms_uia/locators"
require File.dirname(__FILE__) + "/ms_uia/window"
