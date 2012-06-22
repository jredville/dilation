# Dilation

A timer that provides an event based interface to hook into for your app. In addition, the back end timer can be swapped out, so for testing, you can control the passage of time.  

[![Build Status](https://secure.travis-ci.org/jredville/dilation.png)](http://travis-ci.org/jredville/dilation)

## Synopsis

``` ruby
require 'rubygems'
require 'dilation'

class WakeHandler
  def call
    puts 'awake'
  end
end

def stop_handler
  puts 'stop'
end

c = Dilation::Core.new

trap 'INT' do
  c.stop
  abort
end

c.listen_for :start do puts 'start' end
c.listen_for :stop, method(:stop_handler)
c.listen_for :sleep, lambda { puts 'sleep' }
c.listen_for :wake, WakeHandler.new
c.listen_for :tick, lambda { puts 'tick' }

puts 'sleeping'

c.sleep 5

puts 'starting'
counter = 0

c.listen_for :tick, lambda { counter += 1 }

c.start
while counter < 5
end

c.stop

puts 'ok'
```

TODO

## Installation

Add this line to your application's Gemfile:

    gem 'dilation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dilation

## Usage

The [rubydoc.info docs](http://rubydoc.info/gems/dilation/frames) contain
API documentation. The API docs contain detailed info about all of Dilation's public API.

## Release Policy

Dilation follows the principles of [semantic versioning](http://semver.org/).
The [API documentation](http://rubydoc.info/gems/dilation/frames) define
Dilation's public API.  Patch level releases contain only bug fixes.  Minor
releases contain backward-compatible new features.  Major new releases
contain backwards-incompatible changes to the public API.

## Ruby Interpreter Compatibility

Dilation has been tested on the following ruby interpreters:

* MRI 1.9.2-p320
* MRI 1.9.3-p194

## Development

* Source hosted on [GitHub](http://github.com/jredville/dilation).
* Report issues on [GitHub Issues](http://github.com/jredville/dilation/issues).
* Pull requests are very welcome! Please include spec and/or feature coverage for every patch,
  and create a topic branch for every separate change you make.
* Documentation is generated with [YARD](http://yardoc.org/) ([cheat sheet](http://cheat.errtheblog.com/s/yard/)).
  To generate while developing:

```
yard server --reload
```

## Todo

* Better interface to swap backend
* dilation/test_support
* [Code Climate](http://codeclimate.com)
* [Travis](http://travis-ci.org/)
** test on interpreters
*** Rubinius
* make Celluloid optional
* ability to override Kernel#sleep
* 1.8.7 support (?)

## Thanks

* [Myron Marston](http://github.com/myronmarston) for [VCR](http://github.com/myronmarston/vcr), which wasn't used here, but influences how I want to run this project and this readme.
* [Microsoft's Reactive Extensions](http://msdn.microsoft.com/en-us/data/gg577609.aspx) team for the idea of [controlling the flow of time](http://channel9.msdn.com/Shows/Going+Deep/Wes-Dyer-and-Jeffrey-Van-Gogh-Inside-Rx-Virtual-Time)

## Copyright

Copyright (c) 2010-2012 Jim Deville. Released under the terms of the
MIT license. See LICENSE for details.
