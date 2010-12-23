begin
  gem "ffi", "0.6.3"
rescue Gem::LoadError
  raise Gem::LoadError, "Unable to load FFI gem. Install it with:\n\tgem install ffi -v 0.6.3"
end
require "ffi"
require File.dirname(__FILE__) + "/ffi/constants"
require File.dirname(__FILE__) + "/ffi/functions"
require File.dirname(__FILE__) + "/ffi/locators"
require File.dirname(__FILE__) + "/ffi/window"
require File.dirname(__FILE__) + "/ffi/button"
require File.dirname(__FILE__) + "/ffi/text_field"