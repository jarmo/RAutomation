# RAutomation

[![Gem Version](https://badge.fury.io/rb/rautomation.png)](http://badge.fury.io/rb/rautomation)

*   Web: http://www.github.com/jarmo/RAutomation
*   Author: Jarmo Pertman [jarmo@jarmopertman.com](mailto:jarmo@jarmopertman.com)


RAutomation is a small and easy to use library for helping out to automate
windows and their controls for automated testing.

RAutomation provides:
*   Easy to use and user-friendly API (inspired by [Watir](http://www.watir.com))
*   Cross-platform compatibility
*   Easy extensibility - with small scripting effort it's possible to add
    support for not yet  supported platforms or technologies


## USAGE

```ruby
require "rautomation"

window = RAutomation::Window.new(:title => /part of the title/i)
window.exists? # => true

window.title # => "blah blah part Of the title blah"
window.text # => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ultricies..."

window.text_field(:class => "Edit", :index => 0).set "hello, world!"
button = window.button(:value => "&Save")
button.exists? # => true
button.click

all_windows = RAutomation::Window.windows
all_windows.each {|window| puts window.hwnd}

window = RAutomation::Window.new(:title => /part of the title/i)
windows = window.windows
puts windows.size # => 2
windows.map &:title # => ["part of the title 1", "part of the title 2"]

window.windows(:title => /part of other title/i) # => all windows with matching specified title

window.buttons.each {|button| puts button.value}
window.buttons(:value => /some value/i).each {|button| puts button.value}

window2 = RAutomation::Window.new(:title => "Other Title", :adapter => :autoit) # use AutoIt adapter
# use adapter's (in this case AutoIt's) internal methods not part of the public API directly
window2.WinClose("[TITLE:Other Title]")
```

Check out [the documentation](https://rubydoc.info/github/jarmo/RAutomation) for other possible usages!

## INSTALL

### Windows

    gem install rautomation

Available adapters:
*   :win_32 - uses Windows API directly with FFI (default)
*   :ms_uia - an experimental adapter
*   :autoit - uses AutoIt for automation (DEPRECATED)


When using AutoIt adapter: You might need administrative privileges if running
for the first time and you haven't installed AutoIt before!

### Linux

Feel yourself at home on Linux and know how to automate windows and their
controls? I would be happy if you'd contact me about that matter - or even
better, follow the instructions at "How to create a new adapter?" 

### OS X

Feel yourself at home on OS X and know how to automate windows and their
controls? I would be happy if you'd contact me about that matter - or even
better, follow the instructions at "How to create a new adapter?"

### Others

Feel yourself at home on some operating system not listed in here and know how
to automate windows and their controls? Does Ruby also work on that operating
system? I would be happy if you'd contact me about that matter - or even
better, follow the instructions at "How to create a new adapter?"

## Supported Ruby Platforms

64bit Ruby platform is **only supported for Win32 adapter**.
Other adapters can be used only on a 32bit Ruby!

## How to create a new adapter?

1.  Fork the project.
2.  Create entry point file to lib/rautomation/adapter which should load all
    adapter specific files.
3.  Add `autoload` statement into lib/rautomation/adapter/helper.rb for that
    file.
4.  Create a directory for your adapter's specific code into
    lib/rautomation/adapter
5.  Copy button.rb, text_field.rb and window.rb from some of the existing
    adapter's directory.
6.  Add spec data for your adapter into spec/spec_helper DATA constant.
7.  Use environment variable *RAUTOMATION_ADAPTER* to point to that adapter.
8.  Start coding and spec-ing until as much of possible of the public API is
    satisfied.
9.  Make me a pull request.


Don't forget to fix the documentation for that adapter also!

In case of any problems, feel free to contact me.

## Contributors

*   Levi Wilson - https://github.com/leviwilson
*   Eric Kessler - https://github.com/enkessler
*   Stephan Schwab - https://github.com/snscaimito
*   Benjamin Sandland - https://github.com/bensandland


## Libraries Using RAutomation

*   [watir-classic](https://github.com/watir/watir-classic)
*   [mohawk](https://github.com/leviwilson/mohawk)


## Note on Patches/Pull Requests

*   Fork the project.
*   Make your feature addition or bug fix.
*   Add tests for it. This is important so I don't break it in a future
    version unintentionally.
*   Commit, do not mess with rakefile, version, or history.

    (if you want to have your own version, that is fine but bump version in a
    commit by itself I can ignore when I pull)
*   Send me a pull request. Bonus points for topic branches.


## Copyright

Copyright (c) Jarmo Pertman. See LICENSE for details.
