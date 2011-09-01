begin
  gem "ffi"
rescue Gem::LoadError
  raise Gem::LoadError, "Unable to load FFI gem. Install it with:\n\tgem install ffi"
end
require "ffi"
require File.dirname(__FILE__) + "/ms_uia/locators"
require File.dirname(__FILE__) + "/ms_uia/control"
require File.dirname(__FILE__) + "/ms_uia/button"
require File.dirname(__FILE__) + "/ms_uia/window"
require File.dirname(__FILE__) + "/ms_uia/text_field"

#require File.dirname(__FILE__) + "/ms_uia/new_file
